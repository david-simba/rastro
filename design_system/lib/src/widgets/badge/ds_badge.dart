import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final Color color;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double iconSize;

  const DsBadge({
    required this.label,
    this.variant = BadgeVariant.solid,
    this.color = DsColors.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.iconSize = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = variant.backgroundColor(color);
    final fgColor = variant.textColor(color);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DsLayout.spacingMd, vertical: DsLayout.spacingXs),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: DsLayout.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: iconSize, color: fgColor),
            const SizedBox(width: DsLayout.spacingXs),
          ],
          DsText(label, color: fgColor, variant: TextVariant.regular2),
          if (trailingIcon != null) ...[
            const SizedBox(width: DsLayout.spacingXs),
            Icon(trailingIcon, size: iconSize, color: fgColor),
          ],
        ],
      ),
    );
  }
}
