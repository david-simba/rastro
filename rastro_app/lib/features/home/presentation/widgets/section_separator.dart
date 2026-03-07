import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SectionSeparator extends StatelessWidget {
  final String title;

  const SectionSeparator(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return DsText(
      title,
      variant: TextVariant.subtitle,
      bold: true,
    );
  }
}
