import 'dart:convert';

import '../../core/network/api_endpoints.dart';
import '../../core/network/http_service.dart';
import '../../core/network/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HttpService httpService;
  final TokenStore tokenStore;

  AuthRepositoryImpl({required this.httpService, required this.tokenStore});

  @override
  Future<User> login(String email, String password) async {
    final response = await httpService.post(
      ApiEndpoints.authLogin,
      data: {'email': email, 'password': password},
    );

    final data = response['data'];
    final userModel = UserModel.fromJson(data['user']);

    await tokenStore.saveTokens(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );

    return userModel;
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await tokenStore.getRefreshToken();
      if (refreshToken != null) {
        await httpService.post(
          ApiEndpoints.authLogout,
          data: {'refreshToken': refreshToken},
        );
      }
    } finally {
      await tokenStore.clearTokens();
    }
  }

  @override
  Future<void> refreshToken() async {
    final refreshToken = await tokenStore.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');

    final response = await httpService.post(
      ApiEndpoints.authRefresh,
      data: {'refreshToken': refreshToken},
    );

    await tokenStore.saveTokens(
      accessToken: response['data']['accessToken'],
      refreshToken: response['data']['refreshToken'],
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await tokenStore.getAccessToken();
    return token != null;
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await tokenStore.getAccessToken();
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload =
          jsonDecode(
                utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
              )
              as Map<String, dynamic>;

      final userId = payload['userId'] as String?;
      final email = payload['email'] as String? ?? '';
      if (userId == null || userId.isEmpty) return null;

      return User(
        id: userId,
        name: email.isEmpty ? 'User' : email,
        email: email,
      );
    } catch (_) {
      await tokenStore.clearTokens();
      return null;
    }
  }
}
