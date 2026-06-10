import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<void> refreshToken();
  Future<bool> isLoggedIn();
  Future<User?> getCurrentUser();
}
