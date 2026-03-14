import 'package:flutter/material.dart';
import '../text/ds_text.dart';
import 'button_variant.dart';

class DsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final double? width;
  final double? height;
  final bool fullWidth;
  final bool bold;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const DsButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height,
    this.fullWidth = false,
    this.bold = true,
    this.leadingIcon,
    this.trailingIcon,
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
      width: width ?? (fullWidth ? double.infinity : null),
      height: height ?? 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 16, color: variant.textColor),
              const SizedBox(width: 6),
            ],
            DsText(
              text,
              bold: bold,
              color: variant.textColor,
              align: TextAlign.center,
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 6),
              Icon(trailingIcon, size: 16, color: variant.textColor),
            ],
          ],
        ),
      ),
    );
  }
}