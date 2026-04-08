import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:rastro/core/routing/app_routes.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: DsLayout.spacingSm),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DsCircleButton(
            onPressed: () => context.go(AppRoutes.map),
            icon: LucideIcons.map,
            label: 'Mapa',
          ),
          DsCircleButton(
            onPressed: () => context.go(AppRoutes.routes),
            icon: LucideIcons.route,
            label: 'Rutas',
            backgroundColor: DsColors.green500,
          ),
          DsCircleButton(
            onPressed: () {},
            icon: LucideIcons.clock_4,
            label: 'Horarios',
            backgroundColor: DsColors.orange400,
          ),
          DsCircleButton(
            onPressed: () {},
            icon: LucideIcons.star,
            label: 'Favoritos',
            backgroundColor: DsColors.blue600,
          ),
        ],
      ),
    );
  }
}
