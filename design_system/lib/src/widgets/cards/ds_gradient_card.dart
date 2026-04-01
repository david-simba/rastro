import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsGradientCard extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool rounded;

  const DsGradientCard({
    required this.colors,
    required this.child,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.rounded = true,
    super.key,
  });

  List<Color> _normalizeColors(List<Color> colors) {
    return colors.map((c) {
      return Color.lerp(c, Colors.black, 0.08)!;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _normalizeColors(colors),
          begin: begin,
          end: end,
        ),
        borderRadius: rounded ? DsLayout.borderRadiusMd : BorderRadius.zero,
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: DsColors.white),
        child: IconTheme.merge(
          data: const IconThemeData(color: DsColors.white),
          child: child,
        ),
      ),
    );
  }
}
