import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:rastro/features/auth/presentation/widgets/oauth_buttons.dart';

class RegisterForm extends StatelessWidget {
  final VoidCallback onLoginTap;

  const RegisterForm({required this.onLoginTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DsText(
          "Crear Cuenta",
          variant: TextVariant.title,
        ),
        DsText(
          "Completa tus datos para registrarte",
          color: DsColors.zinc500,
        ),
        SizedBox(height: DsLayout.spacingXl),
        DsTextField(
          hint: "Nombre completo",
          leadingIcon: LucideIcons.user,
        ),
        SizedBox(height: DsLayout.spacingLg),
        DsTextField(
          hint: "Correo electrónico",
          leadingIcon: LucideIcons.mail,
        ),
        SizedBox(height: DsLayout.spacingLg),
        DsTextField(
          hint: "Contraseña",
          leadingIcon: LucideIcons.lock,
        ),
        SizedBox(height: DsLayout.spacingLg),
        DsTextField(
          hint: "Confirmar contraseña",
          leadingIcon: LucideIcons.lock,
        ),
        SizedBox(height: DsLayout.spacingXxl),
        DsGradientButton(
          text: 'Crear Cuenta',
          height: 46,
          fullWidth: true,
          colors: [
            DsColors.blue500,
            DsColors.purple500,
          ],
          onPressed: () {},
        ),
        SizedBox(height: DsLayout.spacingXl),
        const DsDivider(label: 'o regístrate con'),
        SizedBox(height: DsLayout.spacingXxl),
        const OAuthButtons(),
        SizedBox(height: DsLayout.spacingXl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DsText(
              "¿Ya tienes cuenta? ",
              color: DsColors.zinc500,
            ),
            DsTextButton(text: "Inicia Sesión", onPressed: onLoginTap),
          ],
        ),
      ],
    );
  }
}
