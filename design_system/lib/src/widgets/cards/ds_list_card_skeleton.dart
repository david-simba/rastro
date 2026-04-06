import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsListCardSkeleton extends StatefulWidget {
  const DsListCardSkeleton({super.key});

  @override
  State<DsListCardSkeleton> createState() => _DsListCardSkeletonState();
}

class _DsListCardSkeletonState extends State<DsListCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? DsColors.zinc700 : DsColors.zinc200;
    final highlightColor = isDark ? DsColors.zinc600 : DsColors.zinc50;

    return Container(
      decoration: BoxDecoration(
        color: dsColors.surface,
        borderRadius: DsLayout.borderRadiusSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: DsLayout.spacingLg + 6,
              right: DsLayout.spacingLg,
              top: DsLayout.spacingLg,
              bottom: DsLayout.spacingXl,
            ),
            child: AnimatedBuilder(
              animation: _controller,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 14,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(DsLayout.radiusXs),
                          ),
                        ),
                        const SizedBox(height: DsLayout.spacingXs),
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(DsLayout.radiusXs),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: DsLayout.spacingMd),
                  Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(DsLayout.radiusXs),
                    ),
                  ),
                ],
              ),
              builder: (_, child) {
                final pos = -0.3 + _controller.value * 1.6;
                return ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [baseColor, highlightColor, baseColor],
                    stops: [
                      (pos - 0.3).clamp(0.0, 1.0),
                      pos.clamp(0.0, 1.0),
                      (pos + 0.3).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: child,
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 6,
            child: ColoredBox(color: baseColor),
          ),
        ],
      ),
    );
  }
}