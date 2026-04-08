import 'package:design_system/design_system.dart';
import 'package:driver_app/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OAuthButtons extends StatelessWidget {
  const OAuthButtons({
    required this.onGoogleTap,
    this.loadingAction,
    super.key,
  });

  final VoidCallback onGoogleTap;
  final AuthAction? loadingAction;

  @override
  Widget build(BuildContext context) {
    return DsButton(
      text: 'Google',
      fullWidth: true,
      variant: ButtonVariant.outlined,
      color: context.dsColors.border,
      textColor: context.dsColors.onSurface,
      isLoading: loadingAction == AuthAction.google,
      leading: loadingAction == AuthAction.google
          ? null
          : SvgPicture.asset('assets/svgs/icons/ic_google.svg', width: 16),
      onPressed: onGoogleTap,
    );
  }
}
