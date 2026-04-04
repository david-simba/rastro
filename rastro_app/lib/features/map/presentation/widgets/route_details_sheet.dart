import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:rastro/features/routes/domain/entities/route_entity.dart';

class RouteDetailsSheet extends StatelessWidget {
  final RouteEntity route;

  const RouteDetailsSheet({required this.route, super.key});

  @override
  Widget build(BuildContext context) {
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
      ],
    );
  }
}
