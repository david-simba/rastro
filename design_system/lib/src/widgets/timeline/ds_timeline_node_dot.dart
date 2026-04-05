import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum DsTimelineNodeType { start, mid, end }

class DsTimelineNodeDot extends StatelessWidget {
  final DsTimelineNodeType type;

  const DsTimelineNodeDot({required this.type, super.key});

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
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: colors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: colors.border, width: 1.5),
          ),
        );
    }
  }
}
