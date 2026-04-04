import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/features/map/presentation/providers/map_notifier.dart';
import 'package:rastro/features/routes/presentation/providers/routes_notifier.dart';

class RoutesList extends ConsumerWidget {
  const RoutesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesAsync = ref.watch(routesNotifierProvider);

    return routesAsync.when(
      loading: () => const DsLoader(),
      error: (e, _) => Center(child: DsText('Error: $e')),
      data: (routes) {
        if (routes.isEmpty) {
          return const DsEmptyState(
            icon: LucideIcons.bus_front,
            title: 'Sin rutas disponibles',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: routes.length,
          separatorBuilder: (_, _) => SizedBox(height: DsLayout.spacingSm),
          itemBuilder: (_, i) => DsListCard(
            title: routes[i].name,
            subtitle: '${routes[i].origin} → ${routes[i].destination}',
            accentColor: DsColors.blue500,
            trailing: Icon(LucideIcons.chevron_right, color: DsColors.zinc300),
            onPress: () {
              ref.read(mapNotifierProvider.notifier).selectRoute(routes[i]);
              context.go(AppRoutes.map);
            },
          ),
        );
      },
    );
  }
}
