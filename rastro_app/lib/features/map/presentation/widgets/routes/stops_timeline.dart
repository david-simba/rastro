import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:rastro/features/stops/domain/entities/stop_entity.dart';

class StopsTimeline extends StatelessWidget {
  final List<StopEntity> stops;
  final String? selectedStopId;
  final void Function(StopEntity stop) onStopTap;

  const StopsTimeline({
    required this.stops,
    required this.onStopTap,
    this.selectedStopId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;

    final items = stops.asMap().entries.map((entry) {
      final i = entry.key;
      final stop = entry.value;
      final isFirst = i == 0;
      final isLast = i == stops.length - 1;
      final isSelected = stop.id == selectedStopId;

      final Widget dot = isFirst
          ? const DsTimelineIconDot(
              icon: LucideIcons.bus_front,
              color: DsColors.green500,
            )
          : isLast
              ? const DsTimelineIconDot(
                  icon: LucideIcons.flag,
                  color: DsColors.red400,
                )
              : DsTimelineNodeDot(
                  type: DsTimelineNodeType.mid,
                  isHighlighted: isSelected,
                );

      return DsTimelineItemData(
        dot: dot,
        label: stop.name,
        labelColor: isSelected ? DsColors.blue500 : colors.onSurface,
        lineColor: isSelected ? DsColors.blue500 : colors.border,
        borderColor: isSelected ? DsColors.blue500 : colors.border,
        onTap: () => onStopTap(stop),
      );
    }).toList();

    return DsTimeline(items: items);
  }
}
