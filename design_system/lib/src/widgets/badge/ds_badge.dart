import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../text/ds_text.dart';
import 'badge_variant.dart';

class DsBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final Color color;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const DsBadge({
    required this.label,
    this.variant = BadgeVariant.solid,
    this.color = DsColors.primary,
    this.leadingIcon,
    this.trailingIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = variant.backgroundColor(color);
    final fgColor = variant.textColor(color);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 16, color: fgColor),
            const SizedBox(width: 4),
          ],
          DsText(label, color: fgColor, variant: TextVariant.label, bold: true),
          if (trailingIcon != null) ...[
            const SizedBox(width: 4),
            Icon(trailingIcon, size: 16, color: fgColor),
          ],
        ],
      ),
    );
  }
}