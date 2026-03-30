import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class ToastCard extends StatelessWidget {
  final String title;
  final String message;
  final ToastVariant variant;
  final VoidCallback? onClose;

  const ToastCard({
    required this.title,
    required this.message,
    this.variant = ToastVariant.info,
    this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;
    final color = variant.color;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: DsLayout.spacingMd),
      decoration: BoxDecoration(
        color: dsColors.surface,
        borderRadius: DsLayout.borderRadiusMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(DsLayout.radiusMd),
                  bottomLeft: Radius.circular(DsLayout.radiusMd),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: DsLayout.spacingLg,
                  horizontal: DsLayout.spacingMd,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(variant.icon, color: color, size: 28),
                    const SizedBox(width: DsLayout.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DsText(title, variant: TextVariant.medium, color: dsColors.onSurface),
                          const SizedBox(height: DsLayout.spacingXs),
                          DsText(message, variant: TextVariant.caption, color: dsColors.muted),
                        ],
                      ),
                    ),
                    if (onClose != null) ...[
                      const SizedBox(width: DsLayout.spacingSm),
                      GestureDetector(
                        onTap: onClose,
                        child: Icon(Icons.close, size: 20, color: dsColors.muted),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
