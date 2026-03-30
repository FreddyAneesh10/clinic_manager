import '../domain/entities/user_entity.dart';
import '../domain/repository/auth_repository.dart';

/// Contract for user authentication (DIP).
abstract class LoginInteractor {
  Future<UserEntity> execute(String username, String password);
}

/// Implementation of the Login use case.
class LoginInteractorImpl implements LoginInteractor {
  final AuthRepository _repository;

  LoginInteractorImpl(this._repository);

  @override
  Future<UserEntity> execute(String username, String password) async {
    _validate(username, password);
    return await _repository.login(username, password);
  }

  /// SRP: Encapsulated validation logic separately.
  void _validate(String username, String password) {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Username and password cannot be empty');
    }
  }
}
