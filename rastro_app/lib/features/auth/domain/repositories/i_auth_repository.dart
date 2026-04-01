import 'package:network/network.dart';

import 'package:rastro/features/auth/domain/entities/user.dart';

abstract interface class IAuthRepository {
  Future<Result<User, NetworkError>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Result<User, NetworkError>> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Result<User, NetworkError>> signInWithGoogle();
}
