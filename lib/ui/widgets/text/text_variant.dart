import 'package:flutter/material.dart';
import 'package:rastro/ui/theme/typography.dart';

enum TextVariant {
  headline,
  title,
  subtitle,
  body,
  label,
  caption,
}

extension TextVariantExtension on TextVariant {
  static final _styleMap = <TextVariant, TextStyle>{
    TextVariant.headline: AppTypography.headline,
    TextVariant.title: AppTypography.title,
    TextVariant.subtitle: AppTypography.subtitle,
    TextVariant.body: AppTypography.body,
    TextVariant.label: AppTypography.label,
    TextVariant.caption: AppTypography.caption,
  };

  TextStyle get style {
    return _styleMap[this] ?? AppTypography.body;
  }
}