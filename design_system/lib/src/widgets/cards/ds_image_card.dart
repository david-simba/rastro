import 'package:flutter/material.dart';
import '../../theme/ds_theme_ext.dart';

class DsImageCard extends StatelessWidget {
  final Widget image;
  final Widget? footer;

  const DsImageCard({
    required this.image,
    this.footer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          image,
          if (footer != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: context.dsColors.surface,
              child: footer!,
            ),
        ],
      ),
    );
  }
}
