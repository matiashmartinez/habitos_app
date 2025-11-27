import 'user.dart';

/// Interfaz/contrato del repositorio de autenticación (domain).
abstract class AuthRepository {
  /// Intenta autenticarse y devuelve el User en caso exitoso.
  /// Lanza excepción en caso de error.
  Future<User> login(String email, String password);

  /// Cierra la sesión (si aplica).
  Future<void> logout();

  /// Intenta recuperar una sesión local ya existente (si aplica).
  Future<User?> loadSession();
}
