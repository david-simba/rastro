import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:rastro/features/stops/domain/entities/stop_entity.dart';

class StopsTimeline extends StatelessWidget {
  final List<StopEntity> stops;
  final VoidCallback onFitRoute;
  final void Function(StopEntity stop) onStopTap;

  const StopsTimeline({
    required this.stops,
    required this.onFitRoute,
    required this.onStopTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final total = 1 + stops.length;

    return Column(
      children: [
        _TimelineItem(
          isFirst: true,
          isLast: total == 1,
          lineColor: colors.border,
          dot: _FitRouteDot(),
          label: 'Ver ruta completa',
          labelColor: DsColors.blue500,
          onTap: onFitRoute,
        ),
        ...stops.asMap().entries.map((entry) {
          final i = entry.key;
          final stop = entry.value;
          final isLast = i == stops.length - 1;

          return _TimelineItem(
            isFirst: false,
            isLast: isLast,
            lineColor: colors.border,
            dot: _StopDot(isFirst: i == 0, isLast: isLast),
            label: stop.name,
            labelColor: colors.onSurface,
            onTap: () => onStopTap(stop),
          );
        }),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Color lineColor;
  final Widget dot;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const _TimelineItem({
    required this.isFirst,
    required this.isLast,
    required this.lineColor,
    required this.dot,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: DsLayout.borderRadiusSm,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  if (!isFirst)
                    Expanded(
                      child: Center(
                        child: Container(width: 1.5, color: lineColor),
                      ),
                    )
                  else
                    const SizedBox(height: 10),
                  dot,
                  if (!isLast)
                    Expanded(
                      child: Center(
                        child: Container(width: 1.5, color: lineColor),
                      ),
                    )
                  else
                    const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DsText(
                  label,
                  variant: TextVariant.regular2,
                  color: labelColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FitRouteDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: DsColors.blue500.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: DsColors.blue500, width: 1.5),
      ),
      child: const Icon(LucideIcons.route, size: 13, color: DsColors.blue500),
    );
  }
}

class _StopDot extends StatelessWidget {
  final bool isFirst;
  final bool isLast;

  const _StopDot({required this.isFirst, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;

    if (isFirst) {
      return Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: DsColors.green500,
          shape: BoxShape.circle,
        ),
      );
    }

    if (isLast) {
      return Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: DsColors.red400,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: colors.border, width: 1.5),
      ),
    );
  }
}
