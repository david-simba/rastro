import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:rastro/features/stops/domain/entities/stop_entity.dart';

class StopsTimeline extends StatelessWidget {
  final List<StopEntity> stops;
  final String? selectedStopId;
  final VoidCallback onFitRoute;
  final void Function(StopEntity stop) onStopTap;

  const StopsTimeline({
    required this.stops,
    required this.onFitRoute,
    required this.onStopTap,
    this.selectedStopId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;

    final items = <DsTimelineItemData>[
      DsTimelineItemData(
        dot: const DsTimelineIconDot(
          icon: LucideIcons.route,
          color: DsColors.blue500,
        ),
        label: 'Ver ruta completa',
        labelColor: DsColors.blue500,
        onTap: onFitRoute,
      ),
      ...stops.asMap().entries.map((entry) {
        final i = entry.key;
        final stop = entry.value;
        final isLast = i == stops.length - 1;
        final isSelected = stop.id == selectedStopId;

        final nodeType = i == 0
            ? DsTimelineNodeType.start
            : isLast
                ? DsTimelineNodeType.end
                : DsTimelineNodeType.mid;

        return DsTimelineItemData(
          dot: DsTimelineNodeDot(
            type: nodeType,
            isHighlighted: isSelected,
          ),
          label: stop.name,
          labelColor: isSelected ? DsColors.blue500 : colors.onSurface,
          onTap: () => onStopTap(stop),
        );
      }),
    ];

    return DsTimeline(items: items);
  }
}
