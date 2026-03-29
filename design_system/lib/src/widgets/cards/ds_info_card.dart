import 'package:flutter/material.dart';
import '../../theme/ds_theme_ext.dart';
import '../text/ds_text.dart';
import '../text/text_variant.dart';

class DsInfoCard extends StatelessWidget {
  final String title;
  final String? label;
  final Widget? icon;
  final Widget? trailing;
  final Widget? footer;
  final Color? backgroundColor;
  final VoidCallback? onPress;

  const DsInfoCard({
    required this.title,
    this.label,
    this.icon,
    this.trailing,
    this.footer,
    this.backgroundColor,
    this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;

    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor ?? dsColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: 10),
            ],
            if (label != null || trailing != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (label != null)
                    DsText(label!, variant: TextVariant.caption, color: dsColors.muted),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 2),
            ],
            DsText(title, variant: TextVariant.medium, color: dsColors.onSurface),
            if (footer != null) ...[
              const SizedBox(height: 8),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
