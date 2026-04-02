import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final ButtonVariant variant;
  final Color color;
  final double? size;

  const DsFloatingButton({
    required this.onPressed,
    required this.icon,
    this.variant = ButtonVariant.filled,
    this.color = DsColors.blue500,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isOutlined = variant == ButtonVariant.outlined;
    final fgColor = isOutlined ? color : DsColors.white;

    return SizedBox(
      width: size ?? DsLayout.floatingButtonSize,
      height: size ?? DsLayout.floatingButtonSize,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: isOutlined ? Colors.transparent : color,
        foregroundColor: fgColor,
        shape: isOutlined
            ? CircleBorder(side: BorderSide(color: color))
            : const CircleBorder(),
        elevation: isOutlined ? 0 : 4,
        child: Icon(icon, color: fgColor),
      ),
    );
  }
}
