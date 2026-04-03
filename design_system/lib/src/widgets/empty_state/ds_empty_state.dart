import 'package:flutter/material.dart';

import '../../theme/ds_colors.dart';
import '../../theme/ds_layout.dart';
import '../text/ds_text.dart';
import '../text/text_variant.dart';

class DsEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const DsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: DsColors.zinc300),
          SizedBox(height: DsLayout.spacingMd),
          DsText(title, variant: TextVariant.medium, color: DsColors.zinc500),
          if (subtitle != null) ...[
            SizedBox(height: DsLayout.spacingXs),
            DsText(
              subtitle!,
              variant: TextVariant.caption,
              color: DsColors.zinc500,
              align: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
