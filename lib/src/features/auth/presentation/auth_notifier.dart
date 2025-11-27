import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthUnauthenticated());

  Future<void> login(String email, String password) async {
    state = AuthLoading();

    // Simulación de proceso de login
    await Future.delayed(const Duration(seconds: 2));

    // Validación de ejemplo
    if (email == "test@correo.com" && password == "123456") {
      state = AuthAuthenticated(userId: "123", email: email);
    } else {
      state = AuthError("Credenciales inválidas");
      await Future.delayed(const Duration(seconds: 2));
      state = AuthUnauthenticated();
    }
  }

  void logout() {
    state = AuthUnauthenticated();
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
