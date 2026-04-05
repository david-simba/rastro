import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class RouteStopsHeader extends StatelessWidget {
  final int count;

  const RouteStopsHeader({required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? DsColors.blue900 : DsColors.blue50;
    final textColor = isDark ? DsColors.blue200 : DsColors.blue700;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: DsLayout.spacingMd,
        vertical: DsLayout.spacingSm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: DsLayout.borderRadiusSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (count > 0) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DsText('Paradas', variant: TextVariant.medium, color: textColor),
                const SizedBox(width: DsLayout.spacingXs),
                DsText('$count', variant: TextVariant.medium, color: textColor),
              ],
            ),
            const SizedBox(height: 2),
            DsText(
              'Interactúa con las paradas para ver su ubicación',
              variant: TextVariant.caption,
              color: textColor,
            ),
          ] else
            DsText(
              'Paradas no disponibles para esta ruta',
              variant: TextVariant.caption,
              color: textColor,
            ),
        ],
      ),
    );
  }
}
