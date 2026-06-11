import '../entities/user.dart';
import '../repositories/auth_repository.dart';

abstract class Login {
  Future<User> call(String email, String password);
}

abstract class Logout {
  Future<void> call();
}

abstract class CheckAuth {
  Future<bool> call();
}

class LoginUseCase implements Login {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}

class LogoutUseCase implements Logout {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<void> call() async {
    return await repository.logout();
  }
}

class CheckAuthUseCase implements CheckAuth {
  final AuthRepository repository;

  CheckAuthUseCase(this.repository);

  @override
  Future<bool> call() async {
    return await repository.isLoggedIn();
  }
}
