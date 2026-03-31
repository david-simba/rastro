import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OAuthButtons extends StatelessWidget {
  const OAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DsButton(
            text: "Google",
            variant: ButtonVariant.outlined,
            color: context.dsColors.border,
            textColor: context.dsColors.onSurface,
            leading: SvgPicture.asset('assets/svgs/icons/ic_google.svg', width: 16),
            onPressed: () {},
          ),
        ),
        SizedBox(width: DsLayout.spacingMd),
        Expanded(
          child: DsButton(
            text: "Apple",
            variant: ButtonVariant.outlined,
            color: context.dsColors.border,
            textColor: context.dsColors.onSurface,
            leading: SvgPicture.asset(
              'assets/svgs/icons/ic_apple.svg',
              width: 16,
              colorFilter: ColorFilter.mode(
                context.dsColors.onSurface,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
