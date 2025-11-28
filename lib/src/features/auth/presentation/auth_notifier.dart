import 'package:flutter_riverpod/legacy.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/auth_state.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(LocalStorageService());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LocalStorageService storage;

  AuthNotifier(this.storage) : super(AuthLoading()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final token = await storage.getToken();

    if (token != null && token.isNotEmpty) {
      state = AuthAuthenticated(userId: "123", email: "user@test.com");
    } else {
      state = AuthUnauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = AuthUnauthenticated(message: "Debe completar todos los campos.");
      return;
    }

    if (!email.contains("@")) {
      state = AuthUnauthenticated(message: "Email inválido.");
      return;
    }

    state = AuthLoading();

    await Future.delayed(const Duration(seconds: 1));

    // Simulación de validación
    if (email != "test@correo.com" || password != "123456") {
      state = AuthUnauthenticated(message: "Credenciales incorrectas.");
      return;
    }

    await storage.saveToken("TOKEN_123");

    state = AuthAuthenticated(userId: "123", email: email);
  }

  Future<void> logout() async {
    await storage.clearToken();
    state = AuthUnauthenticated();
  }
}
