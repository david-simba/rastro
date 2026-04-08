import 'package:design_system/design_system.dart';
import 'package:driver_app/core/routing/app_routes.dart';
import 'package:driver_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:driver_app/features/auth/presentation/providers/auth_state.dart';
import 'package:driver_app/features/auth/presentation/widgets/oauth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);
    final loadingAction =
        authState is AuthLoading ? authState.action : null;
    final errorMessage =
        authState is AuthError ? authState.message : null;

    ref.listen(authNotifierProvider, (_, next) {
      if (next is AuthSuccess) {
        context.go(AppRoutes.routeSelection);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DsText('Iniciar Sesión', variant: TextVariant.title),
        DsText('Bienvenido conductor', color: DsColors.zinc500),
        SizedBox(height: DsLayout.spacingXl),
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
        if (errorMessage != null) ...[
          SizedBox(height: DsLayout.spacingMd),
          DsText(
            errorMessage,
            color: DsColors.red500,
            variant: TextVariant.regular2,
          ),
        ],
        SizedBox(height: DsLayout.spacingXxl),
        DsGradientButton(
          text: 'Iniciar sesión',
          height: 46,
          fullWidth: true,
          isLoading: loadingAction == AuthAction.email,
          colors: [DsColors.blue600, DsColors.blue500],
          onPressed: () => notifier.loginWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        ),
        SizedBox(height: DsLayout.spacingXl),
        const DsDivider(label: 'o continuar con'),
        SizedBox(height: DsLayout.spacingXxl),
        OAuthButtons(
          onGoogleTap: notifier.signInWithGoogle,
          loadingAction: loadingAction,
        ),
        SizedBox(height: DsLayout.spacingXxl),
      ],
    );
  }
}
