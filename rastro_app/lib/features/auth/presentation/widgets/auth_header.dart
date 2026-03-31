import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    return DsGradientCard(
      colors: [DsColors.blue500, DsColors.purple500],
      rounded: false,
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop),
        child: SizedBox(
          width: double.infinity,
          height: 224,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.bus, size: 50),
              SizedBox(height: DsLayout.spacingMd),
              DsText(
                'Rastro',
                variant: TextVariant.headline
              ),
              DsText(
                'Tu transporte inteligente',
                variant: TextVariant.medium
              ),
            ],
          ),
        ),
      ),
    );
  }
}
