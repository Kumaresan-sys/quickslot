import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/core/network/api_client.dart';
import 'package:quickslot/core/network/token_storage.dart';
import 'package:quickslot/data/repositories/auth_repository_impl.dart';

void main() {
  group('AuthRepositoryImpl', () {
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(baseUrl: 'http://10.0.2.2:5001', tokenStorage: tokenStorage);
    final repo = AuthRepositoryImpl(apiClient: apiClient, tokenStorage: tokenStorage);

    test('login returns a User', () async {
      final user = await repo.login('test@example.com', 'password123');
      expect(user, isNotNull);
    });

    test('refresh token updates stored access token', () async {
      await repo.login('test@example.com', 'password123');
      await repo.refreshToken();
      final token = await tokenStorage.getAccessToken();
      expect(token, isNotEmpty);
    });
  });
}
