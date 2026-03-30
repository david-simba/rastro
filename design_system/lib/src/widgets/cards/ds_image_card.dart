import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

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
      borderRadius: DsLayout.borderRadiusMd,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          image,
          if (footer != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: DsLayout.spacingLg, vertical: 10),
              color: context.dsColors.surface,
              child: footer!,
            ),
        ],
      ),
    );
  }
}
