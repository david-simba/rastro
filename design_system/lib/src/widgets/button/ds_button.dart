import 'package:flutter/material.dart';
import '../text/ds_text.dart';
import 'button_variant.dart';

class DsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final double? width;
  final double? height;
  final bool bold;
  final IconData? leftIcon;
  final IconData? rightIcon;

  const DsButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height,
    this.bold = true,
    this.leftIcon,
    this.rightIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: variant.backgroundColor,
      foregroundColor: variant.textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
    );

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null) ...[
              Icon(leftIcon, size: 16, color: variant.textColor),
              const SizedBox(width: 6),
            ],
            DsText(
              text,
              bold: bold,
              color: variant.textColor,
              align: TextAlign.center,
            ),
            if (rightIcon != null) ...[
              const SizedBox(width: 6),
              Icon(rightIcon, size: 16, color: variant.textColor),
            ],
          ],
        ),
      ),
    );
  }
}
