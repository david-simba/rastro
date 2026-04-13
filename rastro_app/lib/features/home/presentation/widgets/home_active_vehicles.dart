import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/core/utils/color_utils.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';
import 'package:rastro/features/routes/presentation/providers/routes_notifier.dart';
import 'package:rastro/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rastro/features/vehicles/presentation/providers/vehicles_notifier.dart';

import 'home_separator.dart';

class HomeActiveVehicles extends ConsumerWidget {
  const HomeActiveVehicles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesNotifierProvider);
    final routesAsync = ref.watch(routesNotifierProvider);

    final isLoading = vehiclesAsync.isLoading || routesAsync.isLoading;
    final vehicles = vehiclesAsync.value ?? [];
    final routes = routesAsync.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionSeparator(label: 'Buses en servicio'),
        SizedBox(height: DsLayout.spacingLg),
        if (isLoading)
          Column(
            children: List.generate(
              3,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: DsLayout.spacingSm),
                child: const DsListCardSkeleton(),
              ),
            ),
          )
        else if (vehiclesAsync.hasError)
          Center(child: DsText('Error: ${vehiclesAsync.error}'))
        else
          _buildList(context, vehicles, routes),
      ],
    );
  }

  Widget _buildList(
    BuildContext context,
    List<VehicleEntity> vehicles,
    List<RouteEntity> routes,
  ) {
    final visible = vehicles
        .where((v) => v.status == 'active' || v.status == 'warning')
        .toList();

    if (visible.isEmpty) {
      return const SizedBox(
        height: 200,
        child: DsEmptyState(
          icon: LucideIcons.bus_front,
          title: 'Sin rutas activas por el momento',
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < visible.length; i++) ...[
          if (i > 0) SizedBox(height: DsLayout.spacingSm),
          Builder(builder: (context) {
            final vehicle = visible[i];
            final routeMatches = routes.where((r) => r.id == vehicle.routeId);
            final RouteEntity? route =
                routeMatches.isEmpty ? null : routeMatches.first;

            return DsListCard(
              title: route?.name ?? vehicle.routeId,
              subtitle: route != null
                  ? '${route.origin} → ${route.destination}'
                  : null,
              accentColor: route?.accentColor != null
                  ? hexToColor(route!.accentColor!)
                  : null,
              trailing: _statusBadge(vehicle.status),
              onPress: () => context.go(
                AppRoutes.map,
                extra: {
                  'vehicleId': vehicle.id,
                  'route': route,
                  'lat': vehicle.lat,
                  'lng': vehicle.lng,
                },
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _statusBadge(String status) {
    return switch (status) {
      'active' => DsBadge(
          label: 'En vivo',
          color: DsColors.green500,
          variant: BadgeVariant.soft,
        ),
      'warning' => DsBadge(
          label: 'Alerta',
          color: DsColors.red400,
          variant: BadgeVariant.soft,
        ),
      _ => DsBadge(
          label: 'Inactivo',
          color: DsColors.zinc500,
          variant: BadgeVariant.soft,
        ),
    };
  }
}
