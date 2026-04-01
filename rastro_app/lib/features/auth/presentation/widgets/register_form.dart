import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/features/auth/presentation/providers/auth_notifier.dart';
import 'package:rastro/features/auth/presentation/providers/auth_state.dart';
import 'package:rastro/features/auth/presentation/widgets/oauth_buttons.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({required this.onLoginTap, super.key});

  final VoidCallback onLoginTap;

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(AuthNotifier notifier) {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _confirmPasswordError = 'Las contraseñas no coinciden');
      return;
    }
    setState(() => _confirmPasswordError = null);
    notifier.registerWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);
    final loadingAction = authState is AuthLoading ? authState.action : null;
    final errorMessage = authState is AuthError ? (authState).message : null;

    ref.listen(authNotifierProvider, (_, next) {
      if (next is AuthSuccess) {
        context.go(AppRoutes.home);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DsText('Crear Cuenta', variant: TextVariant.title),
        DsText('Completa tus datos para registrarte', color: DsColors.zinc500),
        SizedBox(height: DsLayout.spacingXl),
        DsTextField(
          hint: 'Nombre completo',
          leadingIcon: LucideIcons.user,
          controller: _nameController,
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: DsLayout.spacingLg),
        DsTextField(
          hint: 'Correo electrónico',
          leadingIcon: LucideIcons.mail,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: DsLayout.spacingLg),
        DsTextField(
          hint: 'Contraseña',
          leadingIcon: LucideIcons.lock,
          controller: _passwordController,
          obscureText: true,
        ),
        SizedBox(height: DsLayout.spacingLg),
        DsTextField(
          hint: 'Confirmar contraseña',
          leadingIcon: LucideIcons.lock,
          controller: _confirmPasswordController,
          obscureText: true,
          errorText: _confirmPasswordError,
        ),
        if (errorMessage != null) ...[
          SizedBox(height: DsLayout.spacingMd),
          DsText(errorMessage, color: DsColors.red500, variant: TextVariant.regular2),
        ],
        SizedBox(height: DsLayout.spacingXxl),
        DsGradientButton(
          text: 'Crear Cuenta',
          height: 46,
          fullWidth: true,
          isLoading: loadingAction == AuthAction.email,
          colors: [DsColors.blue500, DsColors.purple500],
          onPressed: () => _submit(notifier),
        ),
        SizedBox(height: DsLayout.spacingXl),
        const DsDivider(label: 'o regístrate con'),
        SizedBox(height: DsLayout.spacingXxl),
        OAuthButtons(
          onGoogleTap: notifier.signInWithGoogle,
          loadingAction: loadingAction,
        ),
        SizedBox(height: DsLayout.spacingXl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DsText('¿Ya tienes cuenta? ', color: DsColors.zinc500),
            DsTextButton(text: 'Inicia Sesión', onPressed: widget.onLoginTap),
          ],
        ),
      ],
    );
  }
}
