import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SectionSeparator extends StatelessWidget {
  final String title;

  const SectionSeparator(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppText(
      title,
      variant: TextVariant.subtitle,
      bold: true,
    );
  }
}
