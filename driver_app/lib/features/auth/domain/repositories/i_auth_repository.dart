import 'package:driver_app/features/auth/domain/entities/user.dart';
import 'package:network/network.dart';

abstract interface class IAuthRepository {
  Future<Result<User, NetworkError>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Result<User, NetworkError>> signInWithGoogle();
}
