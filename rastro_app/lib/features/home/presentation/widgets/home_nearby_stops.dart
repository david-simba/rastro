import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'home_separator.dart';

class HomeNearbyStops extends StatelessWidget {
  const HomeNearbyStops({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionSeparator(label: 'Paradas Cercanas'),
        SizedBox(height: DsLayout.spacingLg),
        Row(
          children: [
            Expanded(
              child: DsInfoCard(
                icon: Icon(LucideIcons.bus_front, color: DsColors.blue500),
                title: 'La Marín',
                footer: Row(
                  children: [
                    DsBadge(label: 'E35', variant: BadgeVariant.soft),
                    SizedBox(width: DsLayout.spacingSm),
                    DsBadge(label: 'C1', variant: BadgeVariant.solid),
                  ],
                ),
              ),
            ),
            SizedBox(width: DsLayout.spacingMd),
            Expanded(
              child: DsInfoCard(
                icon: Icon(LucideIcons.bus_front, color: DsColors.blue500),
                title: 'La Cocha',
                footer: Row(
                  children: [
                    DsBadge(label: 'Translatinos', variant: BadgeVariant.soft),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
