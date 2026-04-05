import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:rastro/features/routes/domain/entities/route_entity.dart';

class RouteDetailsHeader extends StatelessWidget {
  final RouteEntity route;

  const RouteDetailsHeader({required this.route, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 44,
          decoration: BoxDecoration(
            color: DsColors.blue500,
            borderRadius: DsLayout.borderRadiusSm,
          ),
          child: const Icon(LucideIcons.route, size: 20, color: Colors.white),
        ),
        const SizedBox(width: DsLayout.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsText(route.name, variant: TextVariant.subtitle),
              Row(
                children: [
                  Icon(LucideIcons.map_pin, size: 12, color: colors.muted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: DsText(
                      '${route.origin} → ${route.destination}',
                      variant: TextVariant.caption,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
