import '../../../../core/domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final data = await _dataSource.login(username, password);
      return UserEntity(
        id: data['id'],
        username: data['username'],
        role: data['role'],
      );
    } catch (e) {
      // Re-throw the exception so the interactor can handle it
      rethrow;
    }
  }
}
