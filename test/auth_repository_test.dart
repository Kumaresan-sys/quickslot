import 'package:flutter_test/flutter_test.dart';

import 'package:quickslot/core/network/token_storage.dart';
import 'package:quickslot/data/repositories/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mock_api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group('AuthRepositoryImpl', () {
    final tokenStorage = TokenStorage();
    final apiClient = MockApiClient.create(tokenStorage);
    final repo = AuthRepositoryImpl(
      httpService: apiClient,
      tokenStore: tokenStorage,
    );

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
