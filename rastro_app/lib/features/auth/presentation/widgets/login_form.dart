import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:rastro/core/routing/app_routes.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

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
      ],
    );
  }
}
