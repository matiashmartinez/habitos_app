import '../domain/auth_repository.dart';
import '../domain/user.dart';
import 'auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;

  AuthRepositoryImpl(this._api);

  @override
  Future<User> login(String email, String password) async {
    final data = await _api.login(email, password);
    return User(
      userId: data['id'] as String,
      email: data['email'] as String,
    );
  }

  @override
  Future<void> logout() async {
    await _api.logout();
  }

  @override
  Future<User?> loadSession() async {
    // Implementación mínima por ahora (sin persistencia local).
    // En Etapa 3 agregaremos SharedPreferences / secure storage.
    return null;
  }
}
