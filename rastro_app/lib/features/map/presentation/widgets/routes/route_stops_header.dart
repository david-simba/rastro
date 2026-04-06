import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class RouteStopsHeader extends StatelessWidget {
  final int count;
  final VoidCallback? onFitRoute;

  const RouteStopsHeader({required this.count, this.onFitRoute, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? DsColors.zinc300 : DsColors.zinc900;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DsLayout.spacingXs,
        vertical: DsLayout.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (count > 0) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DsText('Explora las $count paradas',
                    variant: TextVariant.medium, color: textColor),
                const SizedBox(width: DsLayout.spacingSm),
                if (onFitRoute != null)
                  DsTextButton(
                    text: 'Ver ruta completa',
                    onPressed: onFitRoute!,
                    variant: TextVariant.medium2,
                  ),
              ],
            ),
            const SizedBox(height: 2),
            DsText(
              'Selecciona una parada de la lista para ubicarla en el mapa',
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