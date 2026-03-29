import 'package:flutter/material.dart';
import '../../theme/ds_typography.dart';

enum TextVariant {
  headline,
  title,
  subtitle,
  regular,
  regular2,
  medium,
  medium2,
  caption,
}

extension TextVariantExtension on TextVariant {
  static final _styleMap = <TextVariant, TextStyle>{
    TextVariant.headline: DsTypography.headline,
    TextVariant.title: DsTypography.title,
    TextVariant.subtitle: DsTypography.subtitle,
    TextVariant.regular: DsTypography.regular,
    TextVariant.regular2: DsTypography.regular2,
    TextVariant.medium: DsTypography.medium,
    TextVariant.medium2: DsTypography.medium2,
    TextVariant.caption: DsTypography.caption,
  };

  TextStyle get style {
    return _styleMap[this] ?? DsTypography.regular;
  }
}
