class UserEntity {
  final String id;
  final String username;
  final String role; // 'receptionist' or 'doctor'

  const UserEntity({
    required this.id,
    required this.username,
    required this.role,
  });
}
