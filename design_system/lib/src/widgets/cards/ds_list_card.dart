import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsListCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPress;

  const DsListCard({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;

    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DsLayout.spacingLg, vertical: 14),
        decoration: BoxDecoration(
          color: dsColors.surface,
          borderRadius: DsLayout.borderRadiusMd,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: DsLayout.spacingMd),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DsText(title, variant: TextVariant.medium, color: dsColors.onSurface),
                  if (subtitle != null)
                    DsText(subtitle!, variant: TextVariant.regular2, color: dsColors.muted),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: DsLayout.spacingMd),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
