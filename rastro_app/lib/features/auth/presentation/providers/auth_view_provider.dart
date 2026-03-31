import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthView { login, register }

final authViewProvider =
    NotifierProvider<AuthViewNotifier, AuthView>(AuthViewNotifier.new);

class AuthViewNotifier extends Notifier<AuthView> {
  @override
  AuthView build() => AuthView.login;

  void showRegister() => state = AuthView.register;
  void showLogin() => state = AuthView.login;
}
