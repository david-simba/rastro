import 'package:flutter/material.dart';
import 'package:app_ui/src/widgets/text/app_text.dart';
import 'package:app_ui/src/widgets/text/text_variant.dart';
import 'toast_variant.dart';

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
    final color = variant.color;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(variant.icon, color: color, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(title, bold: true, variant: TextVariant.body),
                          const SizedBox(height: 4),
                          AppText(message, variant: TextVariant.caption, color: Colors.grey[700]),
                        ],
                      ),
                    ),
                    if (onClose != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onClose,
                        child: const Icon(Icons.close, size: 20, color: Colors.black54),
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
