import '../auth_repository.dart';
import '../user.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> call(String email, String password) {
    return _repository.login(email, password);
  }
}
