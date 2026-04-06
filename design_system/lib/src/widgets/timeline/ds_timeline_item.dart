import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsTimelineItem extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Color lineColor;
  final Color? borderColor;
  final bool plain;
  final Widget dot;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const DsTimelineItem({
    required this.isFirst,
    required this.isLast,
    required this.lineColor,
    required this.dot,
    required this.label,
    required this.labelColor,
    required this.onTap,
    this.borderColor,
    this.plain = false,
    super.key,
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
              width: 36,
              child: Column(
                children: [
                  if (!isFirst)
                    Expanded(
                      child: Center(
                        child: Container(width: 1.5, color: lineColor),
                      ),
                    )
                  else
                    const SizedBox(height: 12),
                  dot,
                  if (!isLast)
                    Expanded(
                      child: Center(
                        child: Container(width: 1.5, color: lineColor),
                      ),
                    )
                  else
                    const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: plain
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: DsText(
                        label,
                        variant: TextVariant.regular2,
                        color: labelColor,
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(DsLayout.spacingSm),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: borderColor ?? lineColor.withAlpha(50),
                          width: 0.75,
                        ),
                        borderRadius: DsLayout.borderRadiusSm,
                      ),
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