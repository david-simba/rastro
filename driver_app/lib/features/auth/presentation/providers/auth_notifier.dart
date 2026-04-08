import 'package:driver_app/core/providers/core_providers.dart';
import 'package:driver_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:driver_app/features/auth/presentation/providers/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/network.dart';

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthInitial();

  IAuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading(AuthAction.email);
    final result =
        await _repo.loginWithEmail(email: email, password: password);
    state = result.when(
      success: AuthSuccess.new,
      failure: (e) => AuthError(_errorMessage(e)),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AuthLoading(AuthAction.google);
    final result = await _repo.signInWithGoogle();
    state = result.when(
      success: AuthSuccess.new,
      failure: (e) => AuthError(_errorMessage(e)),
    );
  }

  Future<void> signOut() async {
    await fb.FirebaseAuth.instance.signOut();
    state = const AuthInitial();
  }

  void reset() => state = const AuthInitial();

  static String _errorMessage(NetworkError error) => switch (error) {
        UnauthorizedError() => 'Credenciales inválidas',
        NotFoundError() => 'Usuario no encontrado',
        NoConnectionError() => 'Sin conexión a internet',
        TimeoutError() => 'Tiempo de espera agotado, intentá de nuevo',
        ServerError() => 'Error del servidor, intentá más tarde',
        UnknownError(:final cause) => cause.toString(),
      };
}
