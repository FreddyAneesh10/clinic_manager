import '../domain/entities/user_entity.dart';
import '../domain/repository/auth_repository.dart';

class LoginInteractor {
  final AuthRepository _repository;

  LoginInteractor(this._repository);

  Future<UserEntity> execute(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password cannot be empty');
    }
    return await _repository.login(username, password);
  }
}
