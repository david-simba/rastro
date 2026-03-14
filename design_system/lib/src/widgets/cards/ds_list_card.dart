import 'package:flutter/material.dart';
import '../../theme/colors.dart';
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
    return GestureDetector(
      onTap: onPress,
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: DsColors.white,
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
                DsText(title, bold: true, color: DsColors.black),
                if (subtitle != null) ...[
                  DsText(subtitle!, variant: TextVariant.caption),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    ));
  }
}
