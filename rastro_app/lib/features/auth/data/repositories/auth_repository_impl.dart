import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:network/network.dart';

import 'package:rastro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:rastro/features/auth/domain/entities/user.dart';
import 'package:rastro/features/auth/domain/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  Future<Result<User, NetworkError>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _callLogin();
    } on fb.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseError(e));
    }
  }

  @override
  Future<Result<User, NetworkError>> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return (await _datasource.register(
      email: email,
      password: password,
      displayName: displayName,
    ))
        .map((dto) => dto.toDomain());
  }

  @override
  Future<Result<User, NetworkError>> signInWithGoogle() async {
    try {
      await _signInWithGoogle();
      return _callLogin();
    } on fb.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseError(e));
    } catch (e) {
      return Failure(UnknownError(e));
    }
  }

  Future<Result<User, NetworkError>> _callLogin() async {
    final idToken = await fb.FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) return const Failure(UnauthorizedError());
    return (await _datasource.login(idToken)).map((dto) => dto.toDomain());
  }

  Future<fb.User?> _signInWithGoogle() async {
    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) throw Exception('Google idToken is null');

    final credential = fb.GoogleAuthProvider.credential(idToken: idToken);
    final result =
        await fb.FirebaseAuth.instance.signInWithCredential(credential);
    return result.user;
  }

  static NetworkError _mapFirebaseError(fb.FirebaseAuthException e) =>
      switch (e.code) {
        'wrong-password' || 'invalid-credential' => const UnauthorizedError(),
        'user-not-found' => const NotFoundError(),
        'network-request-failed' => const NoConnectionError(),
        _ => UnknownError(e.message ?? e.code),
      };
}
