import 'package:driver_app/features/auth/domain/entities/user.dart';
import 'package:driver_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:network/network.dart';

class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl();

  @override
  Future<Result<User, NetworkError>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await fb.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return Success(_toUser(credential.user!));
    } on fb.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseError(e));
    }
  }

  @override
  Future<Result<User, NetworkError>> signInWithGoogle() async {
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) throw Exception('Google idToken is null');

      final credential = fb.GoogleAuthProvider.credential(idToken: idToken);
      final result =
          await fb.FirebaseAuth.instance.signInWithCredential(credential);
      return Success(_toUser(result.user!));
    } on fb.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseError(e));
    } catch (e) {
      return Failure(UnknownError(e));
    }
  }

  User _toUser(fb.User fbUser) => User(
        userId: fbUser.uid,
        email: fbUser.email!,
        displayName: fbUser.displayName,
        photoUrl: fbUser.photoURL,
      );

  static NetworkError _mapFirebaseError(fb.FirebaseAuthException e) =>
      switch (e.code) {
        'wrong-password' || 'invalid-credential' => const UnauthorizedError(),
        'user-not-found' => const NotFoundError(),
        'network-request-failed' => const NoConnectionError(),
        _ => UnknownError(e.message ?? e.code),
      };
}
