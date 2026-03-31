import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const DsTextButton({
    required this.text,
    required this.onPressed,
    this.color = DsColors.blue500,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: DsText(text, variant: TextVariant.medium, color: color),
    );
  }
}
