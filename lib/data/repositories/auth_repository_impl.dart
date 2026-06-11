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
    if (!await isLoggedIn()) return null;
    // In a real app, you might have a /users/me endpoint.
    // For now, we return a mock or rely on the cached token if valid.
    // The QuickSlot API provided doesn't explicitly show a GET /me endpoint in test_endpoints.js.
    // However, the login returns the user. We could cache the user info along with the token.
    return null;
  }
}
