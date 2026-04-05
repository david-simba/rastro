import 'package:design_system/design_system.dart';
import 'package:design_system/src/widgets/timeline/ds_timeline_item.dart';
import 'package:flutter/material.dart';

class DsTimelineItemData {
  final Widget dot;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const DsTimelineItemData({
    required this.dot,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });
}

class DsTimeline extends StatelessWidget {
  final List<DsTimelineItemData> items;

  const DsTimeline({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final total = items.length;

    return Column(
      children: items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return DsTimelineItem(
          isFirst: i == 0,
          isLast: i == total - 1,
          lineColor: colors.border,
          dot: item.dot,
          label: item.label,
          labelColor: item.labelColor,
          onTap: item.onTap,
        );
      }).toList(),
    );
  }
}
