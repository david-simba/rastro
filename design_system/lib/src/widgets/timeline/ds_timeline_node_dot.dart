import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum DsTimelineNodeType { start, mid, end }

class DsTimelineNodeDot extends StatelessWidget {
  final DsTimelineNodeType type;
  final bool isHighlighted;

  const DsTimelineNodeDot({
    required this.type,
    this.isHighlighted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;

    switch (type) {
      case DsTimelineNodeType.start:
        return Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            color: DsColors.green500,
            shape: BoxShape.circle,
          ),
        );
      case DsTimelineNodeType.end:
        return Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            color: DsColors.red400,
            shape: BoxShape.circle,
          ),
        );
      case DsTimelineNodeType.mid:
        return Container(
          width: isHighlighted ? 12 : 8,
          height: isHighlighted ? 12 : 8,
          margin: EdgeInsets.symmetric(horizontal: isHighlighted ? 8 : 10),
          decoration: BoxDecoration(
            color: isHighlighted ? DsColors.blue500 : colors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isHighlighted ? DsColors.blue500 : colors.border,
              width: 1.5,
            ),
          ),
        );
    }
  }
}
