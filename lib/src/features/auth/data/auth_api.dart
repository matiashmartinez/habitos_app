// ignore: dangling_library_doc_comments
/// Fake API para simulación.
/// Reemplazar por llamadas reales al backend cuando esté disponible.

class AuthApi {
  /// Simula login: acepta test@test.com / 123456
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulamos latencia de red
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'test@test.com' && password == '123456') {
      return {
        'id': 'user_123',
        'email': email,
      };
    }

    throw Exception('Credenciales inválidas');
  }

  /// Simula logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
