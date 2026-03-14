import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum BadgeVariant {
  solid,
  soft,
}

extension BadgeVariantExtension on BadgeVariant {
  static final _backgroundOpacityMap = <BadgeVariant, double>{
    BadgeVariant.solid: 1.0,
    BadgeVariant.soft: 0.05,
  };

  static final _textColorMap = <BadgeVariant, Color Function(Color)>{
    BadgeVariant.solid: (_) => DsColors.white,
    BadgeVariant.soft: (color) => color,
  };

  double get backgroundOpacity => _backgroundOpacityMap[this] ?? 1.0;

  Color backgroundColor(Color color) => color.withValues(alpha: backgroundOpacity);
  Color textColor(Color color) => _textColorMap[this]!(color);
}