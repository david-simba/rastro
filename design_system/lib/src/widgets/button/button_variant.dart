import 'package:flutter/material.dart';
import '../../theme/ds_colors.dart';

enum ButtonVariant {
  primary,
  danger,
  black,
}

extension ButtonVariantExtension on ButtonVariant {
  static final _backgroundMap = <ButtonVariant, Color>{
    ButtonVariant.primary: DsColors.blue500,
    ButtonVariant.danger: DsColors.orange500,
    ButtonVariant.black: DsColors.black,
  };

  Color get backgroundColor => _backgroundMap[this] ?? DsColors.blue500;
  Color get textColor => DsColors.white;
}
