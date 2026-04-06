import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'package:rastro/features/map/presentation/widgets/routes/route_stops_header.dart';
import 'package:rastro/features/map/presentation/widgets/routes/route_details_header.dart';
import 'package:rastro/features/map/presentation/widgets/routes/route_stops_section.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';

class RouteDetailsSheet extends StatelessWidget {
  final RouteEntity route;
  final VoidCallback? onStopTap;

  const RouteDetailsSheet({required this.route, this.onStopTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RouteDetailsHeader(route: route),
        SizedBox(height: DsLayout.spacingLg),
        RouteStopsHeader(count: route.stops.length),
        SizedBox(height: DsLayout.spacingSm),
        RouteStopsSection(route: route, onStopTap: onStopTap),
      ],
    );
  }
}
