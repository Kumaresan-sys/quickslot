import 'package:dio/dio.dart';
import 'auth_token_refresher.dart';
import 'http_service.dart';
import 'token_storage.dart';
import '../utils/connectivity_service.dart';

class ApiClient implements HttpService {
  final Dio dio;
  final TokenStore tokenStore;
  final ConnectivityChecker connectivityChecker;
  final TokenRefresher? tokenRefresher;
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
    required this.tokenStore,
    this.connectivityChecker = const AlwaysConnectedChecker(),
    this.tokenRefresher,
    Dio? dio,
  }) : dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: const Duration(seconds: 10),
               receiveTimeout: const Duration(seconds: 10),
               headers: {'Content-Type': 'application/json'},
             ),
           ) {
    this.dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
    this.dio.interceptors.add(_connectivityInterceptor());
    this.dio.interceptors.add(_authInterceptor());
  }

  Interceptor _connectivityInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final isConnected = await connectivityChecker.isConnected;
        if (!isConnected) {
          return handler.reject(
            DioException.connectionError(
              requestOptions: options,
              reason: 'No internet connection',
            ),
          );
        }
        return handler.next(options);
      },
    );
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await tokenStore.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401 && tokenRefresher != null) {
          try {
            final newAccessToken = await tokenRefresher!.refreshAccessToken();
            if (newAccessToken != null) {
              e.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              final retryResponse = await dio.fetch(e.requestOptions);
              return handler.resolve(retryResponse);
            }
          } catch (_) {
            await tokenStore.clearTokens();
          }
        }
        return handler.next(e);
      },
    );
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.get(path, queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }
}
