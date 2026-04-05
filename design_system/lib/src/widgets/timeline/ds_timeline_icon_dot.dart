import 'package:flutter/material.dart';

class DsTimelineIconDot extends StatelessWidget {
  final IconData icon;
  final Color color;

  const DsTimelineIconDot({
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: color.withAlpha(2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }
}
