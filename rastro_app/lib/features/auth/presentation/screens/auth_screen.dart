import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/features/auth/presentation/providers/auth_view_provider.dart';
import 'package:rastro/features/auth/presentation/widgets/auth_header.dart';
import 'package:rastro/features/auth/presentation/widgets/auth_sheet.dart';
import 'package:rastro/features/auth/presentation/widgets/login_form.dart';
import 'package:rastro/features/auth/presentation/widgets/register_form.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(authViewProvider);
    final notifier = ref.read(authViewProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          const AuthHeader(),
          AuthSheet(
            child: view == AuthView.register
                ? RegisterForm(
                    key: const ValueKey('register'),
                    onLoginTap: notifier.showLogin,
                  )
                : LoginForm(
                    key: const ValueKey('login'),
                    onRegisterTap: notifier.showRegister,
                  ),
          ),
        ],
      ),
    );
  }
}
