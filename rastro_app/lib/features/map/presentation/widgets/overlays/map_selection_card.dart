import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:rastro/features/map/presentation/providers/map_selection_provider.dart';

class MapSelectionCard extends StatelessWidget {
  final MapSelectedItem item;

  const MapSelectionCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;

    final (IconData icon, String label) = switch (item) {
      MapSelectedStop(:final stop) => (LucideIcons.map_pin, stop.name),
      MapSelectedRoute() => (LucideIcons.route, 'Ruta completa'),
      MapSelectedLocation() => (LucideIcons.locate_fixed, 'Ubicación actual'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DsLayout.spacingMd,
        vertical: DsLayout.spacingSm,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: DsLayout.borderRadiusMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: DsColors.blue500),
          const SizedBox(width: DsLayout.spacingSm),
          Flexible(
            child: DsText(
              label,
              variant: TextVariant.medium,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
