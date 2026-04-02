import 'package:rastro/features/auth/domain/entities/user.dart';

enum AuthAction { email, google }

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading(this.action);
  final AuthAction action;
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final User user;
}

final class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}
