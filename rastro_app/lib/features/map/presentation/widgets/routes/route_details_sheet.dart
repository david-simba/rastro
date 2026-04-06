import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rastro/features/map/presentation/providers/map_selection_provider.dart';
import 'package:rastro/features/map/presentation/widgets/routes/route_details_header.dart';
import 'package:rastro/features/map/presentation/widgets/routes/route_stops_header.dart';
import 'package:rastro/features/map/presentation/widgets/routes/route_stops_section.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';

class RouteDetailsSheet extends ConsumerWidget {
  final RouteEntity route;

  const RouteDetailsSheet({required this.route, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RouteDetailsHeader(route: route),
        SizedBox(height: DsLayout.spacingSm),
        RouteStopsHeader(
          count: route.stops.length,
          onFitRoute: () => ref
              .read(selectedItemProvider.notifier)
              .select(const MapSelectedRoute()),
        ),
        SizedBox(height: DsLayout.spacingSm),
        RouteStopsSection(route: route),
      ],
    );
  }
}
