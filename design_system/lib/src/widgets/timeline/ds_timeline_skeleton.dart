import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsTimelineSkeleton extends StatefulWidget {
  final int itemCount;

  const DsTimelineSkeleton({this.itemCount = 4, super.key});

  @override
  State<DsTimelineSkeleton> createState() => _DsTimelineSkeletonState();
}

class _DsTimelineSkeletonState extends State<DsTimelineSkeleton>
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? DsColors.zinc700 : DsColors.zinc200;
    final highlightColor = isDark ? DsColors.zinc600 : DsColors.zinc50;

    final labelWidths = [120.0, 90.0, 110.0, 80.0, 100.0, 95.0];

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final pos = -0.3 + _controller.value * 1.6;
        final shader = LinearGradient(
          colors: [baseColor, highlightColor, baseColor],
          stops: [
            (pos - 0.3).clamp(0.0, 1.0),
            pos.clamp(0.0, 1.0),
            (pos + 0.3).clamp(0.0, 1.0),
          ],
        );

        Widget bone(double width, double height, {double radius = 4}) =>
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius),
              ),
            );

        final total = 1 + widget.itemCount;

        final rows = List.generate(total, (i) {
          final isFirst = i == 0;
          final isLast = i == total - 1;
          final isActionItem = i == 0;

          final dot = isActionItem
              ? bone(26, 26, radius: 13)
              : bone(
                  i == 1 || isLast ? 12 : 8,
                  i == 1 || isLast ? 12 : 8,
                  radius: 6,
                );

          final labelWidth = labelWidths[i % labelWidths.length];

          return IntrinsicHeight(
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
                            child: Container(width: 1.5, color: Colors.white),
                          ),
                        )
                      else
                        const SizedBox(height: 8),
                      dot,
                      if (!isLast)
                        Expanded(
                          child: Center(
                            child: Container(width: 1.5, color: Colors.white),
                          ),
                        )
                      else
                        const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: bone(labelWidth, 13),
                    ),
                  ),
                ),
              ],
            ),
          );
        });

        return ShaderMask(
          shaderCallback: (bounds) => shader.createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Column(children: rows),
        );
      },
    );
  }
}
