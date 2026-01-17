import 'package:flutter/material.dart';
import 'package:rastro/ui/widgets/text/app_text.dart';
import 'button_variant.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final double? width;
  final double? height;
  final bool bold;

  const AppButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height,
    this.bold = true,
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
        child: AppText(
          text,
          bold: bold,
          color: variant.textColor,
          align: TextAlign.center,
        ),
      ),
    );
  }
}
