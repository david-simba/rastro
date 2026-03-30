import 'package:flutter/material.dart';
import '../../theme/ds_colors.dart';
import '../text/ds_text.dart';
import '../text/text_variant.dart';

class DsCircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;

  const DsCircleButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.backgroundColor = DsColors.blue500,
    this.foregroundColor = DsColors.white,
    this.size = 56,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
            ),
            child: icon != null
                ? Icon(icon, size: size * 0.4, color: foregroundColor)
                : null,
          ),
        ),
        const SizedBox(height: 6),
        DsText(
          label,
          variant: TextVariant.caption,
          align: TextAlign.center,
        ),
      ],
    );
  }
}
