abstract class IAuthDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
}
