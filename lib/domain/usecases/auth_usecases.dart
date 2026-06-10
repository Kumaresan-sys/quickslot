import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}

class CheckAuthUseCase {
  final AuthRepository repository;

  CheckAuthUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isLoggedIn();
  }
}
