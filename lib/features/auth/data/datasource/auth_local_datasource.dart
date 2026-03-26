import 'auth_datasource.dart';

class AuthLocalDataSource implements IAuthDataSource {
  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (username == 'reception' && password == 'pass123') {
      return {
        'id': 'rec_1',
        'username': 'reception',
        'role': 'receptionist',
      };
    } else if (username == 'doctor' && password == 'pass123') {
      return {
        'id': 'doc_1',
        'username': 'doctor',
        'role': 'doctor',
      };
    } else {
      throw Exception('Invalid username or password');
    }
  }
}
