import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rastro/features/map/presentation/providers/map_notifier.dart';
import 'package:rastro/features/map/presentation/widgets/routes/stops_timeline.dart';
import 'package:rastro/features/map/presentation/widgets/routes/stops_timeline_skeleton.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';
import 'package:rastro/features/stops/presentation/providers/stops_provider.dart';

class RouteDetailsSheet extends ConsumerWidget {
  final RouteEntity route;

  const RouteDetailsSheet({required this.route, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.dsColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DsText(route.name, variant: TextVariant.subtitle),
        SizedBox(height: DsLayout.spacingSm),
        Row(
          children: [
            Icon(LucideIcons.map_pin, size: 14, color: colors.muted),
            const SizedBox(width: 6),
            Expanded(
              child: DsText(
                '${route.origin} → ${route.destination}',
                variant: TextVariant.caption,
              ),
            ),
          ],
        ),
        SizedBox(height: DsLayout.spacingLg),
        DsText('Paradas', variant: TextVariant.medium),
        SizedBox(height: DsLayout.spacingSm),
        if (route.stops.isEmpty)
          DsText(
            'Paradas no disponibles para esta ruta',
            variant: TextVariant.regular2,
            color: colors.muted,
          )
        else
          ref.watch(stopsForIdsProvider(route.stops)).when(
            loading: () => StopsTimelineSkeleton(itemCount: route.stops.length),
            error: (_, _) => DsText(
              'Error al cargar paradas',
              variant: TextVariant.regular2,
              color: colors.muted,
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
          ),
      ],
    );
  }
}
