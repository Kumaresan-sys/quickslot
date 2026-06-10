import '../../core/network/api_client.dart';
import '../../core/network/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.apiClient, required this.tokenStorage});

  @override
  Future<User> login(String email, String password) async {
    final response = await apiClient.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final data = response.data['data'];
    final userModel = UserModel.fromJson(data['user']);
    
    await tokenStorage.saveTokens(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );

    return userModel;
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await apiClient.dio.post('/auth/logout', data: {
          'refreshToken': refreshToken,
        });
      }
    } finally {
      await tokenStorage.clearTokens();
    }
  }

  @override
  Future<void> refreshToken() async {
    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');

    final response = await apiClient.dio.post('/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    
    await tokenStorage.saveTokens(
      accessToken: response.data['data']['accessToken'],
      refreshToken: response.data['data']['refreshToken'],
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await tokenStorage.getAccessToken();
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
