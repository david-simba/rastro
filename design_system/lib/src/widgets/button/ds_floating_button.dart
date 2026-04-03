import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final ButtonVariant variant;
  final Color? color;
  final Color? iconColor;
  final double? size;

  const DsFloatingButton({
    required this.onPressed,
    required this.icon,
    this.variant = ButtonVariant.filled,
    this.color,
    this.iconColor,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.dsColors;
    final isOutlined = variant == ButtonVariant.outlined;
    final resolvedColor = color ?? tokens.surface;
    final resolvedIconColor = iconColor ?? tokens.onSurface;

    final bgColor = isOutlined ? Colors.transparent : resolvedColor;
    final fgColor = isOutlined ? resolvedColor : resolvedIconColor;

    return SizedBox(
      width: size ?? DsLayout.floatingButtonSize,
      height: size ?? DsLayout.floatingButtonSize,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        shape: isOutlined
            ? CircleBorder(side: BorderSide(color: resolvedColor))
            : const CircleBorder(),
        elevation: isOutlined ? 0 : 0.75,
        child: Icon(icon, color: fgColor),
      ),
    );
  }
}
