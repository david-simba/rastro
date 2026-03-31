import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/features/auth/presentation/widgets/auth_header.dart';
import 'package:rastro/features/auth/presentation/widgets/auth_sheet.dart';
import 'package:rastro/features/auth/presentation/widgets/login_form.dart';
import 'package:rastro/features/auth/presentation/widgets/oauth_buttons.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const AuthHeader(),
          AuthSheet(
            child: Column(
              children: [
                const LoginForm(),
                SizedBox(height: DsLayout.spacingXl),
                const DsDivider(label: 'o continuar con'),
                SizedBox(height: DsLayout.spacingXxl),
                const OAuthButtons(),
                SizedBox(height: DsLayout.spacingXl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DsText(
                      "¿No tienes cuenta? ",
                      color: DsColors.zinc500,
                    ),
                    DsTextButton(text: "Registrate", onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
