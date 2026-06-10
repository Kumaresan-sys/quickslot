import 'package:dio/dio.dart';
import 'token_storage.dart';

class ApiClient {
  final Dio dio;
  final TokenStorage tokenStorage;
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
    required this.tokenStorage,
    Dio? dio,
  }) : dio = dio ?? Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        )) {
    this.dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    this.dio.interceptors.add(_authInterceptor());
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await tokenStorage.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token expired, attempt refresh
          final refreshToken = await tokenStorage.getRefreshToken();
          if (refreshToken != null) {
            try {
              final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
              final response = await refreshDio.post('/auth/refresh', data: {
                'refreshToken': refreshToken,
              });

              if (response.statusCode == 200) {
                final newAccessToken = response.data['data']['accessToken'];
                final newRefreshToken = response.data['data']['refreshToken'];

                await tokenStorage.saveTokens(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken,
                );

                // Retry original request
                e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                final cloneReq = await refreshDio.request(
                  e.requestOptions.path,
                  options: Options(
                    method: e.requestOptions.method,
                    headers: e.requestOptions.headers,
                  ),
                  data: e.requestOptions.data,
                  queryParameters: e.requestOptions.queryParameters,
                );
                return handler.resolve(cloneReq);
              }
            } catch (_) {
              await tokenStorage.clearTokens();
              // In a real app, you might emit a global event to force logout here.
            }
          }
        }
        return handler.next(e);
      },
    );
  }
}
