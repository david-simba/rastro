import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/core/utils/color_utils.dart';
import 'package:rastro/features/routes/presentation/providers/routes_notifier.dart';
import 'package:rastro/features/vehicles/presentation/providers/vehicles_notifier.dart';

import 'home_separator.dart';

class HomeActiveVehicles extends ConsumerWidget {
  const HomeActiveVehicles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesNotifierProvider);
    final routesAsync = ref.watch(routesNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionSeparator(label: 'Buses en servicio'),
        SizedBox(height: DsLayout.spacingLg),
        vehiclesAsync.when(
          loading: () => Column(
            children: List.generate(
              3,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: DsLayout.spacingSm),
                child: const DsListCardSkeleton(),
              ),
            ),
          ),
          error: (e, _) => Center(child: DsText('Error: $e')),
          data: (vehicles) {
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

            final routes = routesAsync.asData?.value ?? [];

            return Column(
              children: [
                for (int i = 0; i < visible.length; i++) ...[
                  if (i > 0) SizedBox(height: DsLayout.spacingSm),
                  Builder(builder: (context) {
                    final vehicle = visible[i];
                    final route = routes.where((r) => r.id == vehicle.routeId).firstOrNull;

                    return DsListCard(
                      title: route?.name ?? vehicle.routeId,
                      subtitle: route != null
                          ? '${route.origin} → ${route.destination}'
                          : null,
                      accentColor: route?.accentColor != null
                          ? hexToColor(route!.accentColor!)
                          : null,
                      trailing: _statusBadge(vehicle.status),
                    );
                  }),
                ],
              ],
            );
          },
        ),
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
