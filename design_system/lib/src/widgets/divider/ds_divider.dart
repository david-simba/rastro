import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsDivider extends StatelessWidget {
  final String? label;

  const DsDivider({this.label, super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = context.dsColors.border;

    if (label == null) {
      return Divider(color: borderColor, thickness: 0.5, height: 1);
    }

    return Row(
      children: [
        Expanded(child: Divider(color: borderColor, thickness: 0.5, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DsLayout.spacingMd),
          child: DsText(label!, variant: TextVariant.regular, color: context.dsColors.muted),
        ),
        Expanded(child: Divider(color: borderColor, thickness: 0.5, height: 1)),
      ],
    );
  }
}
