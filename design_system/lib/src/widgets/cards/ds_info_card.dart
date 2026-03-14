import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../text/ds_text.dart';
import '../text/text_variant.dart';

class DsInfoCard extends StatelessWidget {
  final String title;
  final String? label;
  final Widget? icon;
  final Widget? trailing;
  final Widget? footer;
  final Color? backgroundColor;

  const DsInfoCard({
    required this.title,
    this.label,
    this.icon,
    this.trailing,
    this.footer,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor ?? DsColors.white,
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
                  DsText(label!, variant: TextVariant.caption, color: DsColors.gray), ?trailing,
              ],
            ),
            const SizedBox(height: 2),
          ],
          DsText(title, bold: true, color: DsColors.black),
          if (footer != null) ...[
            const SizedBox(height: 8),
            footer!,
          ],
        ],
      ),
    );
  }
}
