import 'package:flutter/material.dart';
import 'button_variant.dart';

class AppFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final ButtonVariant variant;
  final double? size;

  const AppFloatingButton({
    required this.onPressed,
    required this.icon,
    this.variant = ButtonVariant.primary,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 56,
      height: size ?? 56,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: variant.backgroundColor,
        foregroundColor: variant.textColor,
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(icon),
      ),
    );
  }
}
