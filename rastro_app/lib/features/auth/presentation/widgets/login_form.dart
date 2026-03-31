import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/features/auth/presentation/widgets/oauth_buttons.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback onRegisterTap;

  const LoginForm({required this.onRegisterTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DsText(
          "Iniciar Sesión",
          variant: TextVariant.title,
        ),
        DsText(
          "Bienvenido de vuelta",
          color: DsColors.zinc500,
        ),
        SizedBox(height: DsLayout.spacingXl),
        DsTextField(
          hint: "Correo electrónico",
          leadingIcon: LucideIcons.mail,
        ),
        SizedBox(height: DsLayout.spacingLg),
        DsTextField(
          hint: "Contraseña",
          leadingIcon: LucideIcons.lock,
        ),
        SizedBox(height: DsLayout.spacingXl),
        Align(
          alignment: Alignment.centerRight,
          child: DsTextButton(
            text: '¿Olvidaste tu contraseña?',
            onPressed: () {},
          ),
        ),
        SizedBox(height: DsLayout.spacingXxl),
        DsGradientButton(
          text: 'Iniciar sesión',
          height: 46,
          fullWidth: true,
          colors: [
            DsColors.blue500,
            DsColors.purple500,
          ],
          onPressed: () => context.go(AppRoutes.home),
        ),
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
            DsTextButton(text: "Registrate", onPressed: onRegisterTap),
          ],
        ),
      ],
    );
  }
}
