import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final Color color;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool fullWidth;
  final Widget? leading;
  final Widget? trailing;
  final bool isLoading;

  const DsButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.filled,
    this.color = DsColors.primary,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.fullWidth = false,
    this.leading,
    this.trailing,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isOutlined = variant == ButtonVariant.outlined;
    final fgColor = textColor ?? (isOutlined ? color : DsColors.white);
    final strokeColor = borderColor ?? color;

    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: isOutlined ? Colors.transparent : color,
      foregroundColor: fgColor,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: DsLayout.borderRadiusMd,
        side: isOutlined ? BorderSide(color: strokeColor) : BorderSide.none,
      ),
      elevation: isOutlined ? 0 : 2,
    );

    return SizedBox(
      width: width ?? (fullWidth ? double.infinity : null),
      height: height ?? DsLayout.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: fgColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 10),
                  ],
                  DsText(
                    text,
                    variant: TextVariant.medium,
                    color: fgColor,
                    align: TextAlign.center,
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 6),
                    trailing!,
                  ],
                ],
              ),
      ),
    );
  }
}
