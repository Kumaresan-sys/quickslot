import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'token_storage.dart';

abstract class TokenRefresher {
  Future<String?> refreshAccessToken();
}

class AuthTokenRefresher implements TokenRefresher {
  final Dio dio;
  final TokenStore tokenStore;

  AuthTokenRefresher({
    required String baseUrl,
    required this.tokenStore,
    Dio? dio,
  }) : dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));

  @override
  Future<String?> refreshAccessToken() async {
    final refreshToken = await tokenStore.getRefreshToken();
    if (refreshToken == null) return null;

    final response = await dio.post(
      ApiEndpoints.authRefresh,
      data: {'refreshToken': refreshToken},
    );

    final data = response.data['data'];
    final accessToken = data['accessToken'] as String;

    await tokenStore.saveTokens(
      accessToken: accessToken,
      refreshToken: data['refreshToken'] as String,
    );

    return accessToken;
  }
}
