/// Entidad User (domain)
class User {
  final String userId;
  final String email;

  const User({
    required this.userId,
    required this.email,
  });

  @override
  String toString() => 'User(id: $userId, email: $email)';
}
