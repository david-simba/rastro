import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rastro/features/map/presentation/providers/map_selection_provider.dart';
import 'package:rastro/features/map/presentation/widgets/routes/stops_timeline.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';
import 'package:rastro/features/stops/presentation/providers/stops_provider.dart';

class RouteStopsSection extends ConsumerWidget {
  final RouteEntity route;

  const RouteStopsSection({required this.route, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (route.stops.isEmpty) return const SizedBox.shrink();

    final selectedItem = ref.watch(selectedItemProvider);
    final selectedStopId = selectedItem is MapSelectedStop
        ? selectedItem.stop.id
        : null;

    return ref.watch(stopsForIdsProvider(route.stops)).when(
      loading: () => DsTimelineSkeleton(itemCount: route.stops.length),
      error: (_, _) => DsText(
        'Error al cargar paradas',
        variant: TextVariant.regular2,
        color: context.dsColors.muted,
      ),
      data: (stops) => StopsTimeline(
        stops: stops,
        selectedStopId: selectedStopId,
        onStopTap: (stop) =>
            ref.read(selectedItemProvider.notifier).select(MapSelectedStop(stop)),
      ),
    );
  }
}
