import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SectionSeparator extends StatelessWidget {
  final String label;
  final Widget? trailing;

  const SectionSeparator({
    required this.label,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DsText(
          label,
          variant: TextVariant.subtitle,
          bold: true,
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}