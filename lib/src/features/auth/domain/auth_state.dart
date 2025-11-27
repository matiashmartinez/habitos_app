sealed class AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;

  AuthAuthenticated({required this.userId, required this.email});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
