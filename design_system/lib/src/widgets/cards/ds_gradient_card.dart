import 'package:flutter/material.dart';

class DsGradientCard extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const DsGradientCard({
    required this.colors,
    required this.child,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
