import 'package:flutter/material.dart';
import '../../theme/ds_typography.dart';

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
    TextVariant.headline: DsTypography.headline,
    TextVariant.title: DsTypography.title,
    TextVariant.subtitle: DsTypography.subtitle,
    TextVariant.body: DsTypography.body,
    TextVariant.label: DsTypography.label,
    TextVariant.caption: DsTypography.caption,
  };

  TextStyle get style {
    return _styleMap[this] ?? DsTypography.body;
  }
}
