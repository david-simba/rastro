import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double? width;
  final double? height;
  final bool fullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const DsGradientButton({
    required this.text,
    required this.onPressed,
    required this.colors,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.width,
    this.height,
    this.fullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    super.key,
  }) : assert(colors.length >= 2, 'colors must have at least 2 entries');

  @override
  Widget build(BuildContext context) {
    final double resolvedWidth = width ?? (fullWidth ? double.infinity : 0);
    final double resolvedHeight = height ?? DsLayout.buttonHeight;

    return SizedBox(
      width: fullWidth || width != null ? resolvedWidth : null,
      height: resolvedHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: begin, end: end),
          borderRadius: DsLayout.borderRadiusMd,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: DsColors.white,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: DsLayout.borderRadiusMd,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 16, color: DsColors.white),
                const SizedBox(width: 6),
              ],
              DsText(
                text,
                variant: TextVariant.medium,
                color: DsColors.white,
                align: TextAlign.center,
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 6),
                Icon(trailingIcon, size: 16, color: DsColors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
