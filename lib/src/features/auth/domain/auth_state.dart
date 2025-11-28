// lib/src/features/auth/domain/auth_state.dart
sealed class AuthState {}

final class AuthLoading extends AuthState {}
final class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  AuthAuthenticated({required this.userId, required this.email});
}
final class AuthUnauthenticated extends AuthState {
  final String? message;
  AuthUnauthenticated({this.message});
}
