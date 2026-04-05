import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rastro/features/map/presentation/providers/map_notifier.dart';
import 'package:rastro/features/map/presentation/widgets/routes/stops_timeline.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';
import 'package:rastro/features/stops/presentation/providers/stops_provider.dart';

class RouteStopsSection extends ConsumerWidget {
  final RouteEntity route;

  const RouteStopsSection({required this.route, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (route.stops.isEmpty) return const SizedBox.shrink();

    return ref.watch(stopsForIdsProvider(route.stops)).when(
      loading: () => DsTimelineSkeleton(itemCount: route.stops.length),
      error: (_, _) => DsText(
        'Error al cargar paradas',
        variant: TextVariant.regular2,
        color: context.dsColors.muted,
      ),
      data: (stops) {
        final notifier = ref.read(mapNotifierProvider.notifier);
        return StopsTimeline(
          stops: stops,
          onFitRoute: notifier.fitSelectedRoute,
          onStopTap: (stop) =>
              notifier.flyToStop(stop.latitude, stop.longitude),
        );
      },
    );
  }
}
