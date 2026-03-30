import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final Color color;
  final double? width;
  final double? height;
  final bool fullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const DsButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.filled,
    this.color = DsColors.blue500,
    this.width,
    this.height,
    this.fullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isOutlined = variant == ButtonVariant.outlined;
    final fgColor = isOutlined ? color : DsColors.white;

    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: isOutlined ? Colors.transparent : color,
      foregroundColor: fgColor,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: DsLayout.borderRadiusMd,
        side: isOutlined ? BorderSide(color: color) : BorderSide.none,
      ),
      elevation: isOutlined ? 0 : 2,
    );

    return SizedBox(
      width: width ?? (fullWidth ? double.infinity : null),
      height: height ?? DsLayout.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 16, color: fgColor),
              const SizedBox(width: 6),
            ],
            DsText(
              text,
              variant: TextVariant.medium,
              color: fgColor,
              align: TextAlign.center,
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 6),
              Icon(trailingIcon, size: 16, color: fgColor),
            ],
          ],
        ),
      ),
    );
  }
}
