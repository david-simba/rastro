import 'package:flutter/material.dart';
import '../../theme/ds_theme_ext.dart';
import '../text/ds_text.dart';
import '../text/text_variant.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: dsColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DsText(title, bold: true, color: dsColors.onSurface),
                  if (subtitle != null)
                    DsText(subtitle!, variant: TextVariant.caption, color: dsColors.muted),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
