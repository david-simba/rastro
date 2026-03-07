import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum ButtonVariant {
  primary,
  danger,
  black,
}

extension ButtonVariantExtension on ButtonVariant {
  static final _backgroundMap = <ButtonVariant, Color>{
    ButtonVariant.primary: DsColors.primary,
    ButtonVariant.danger: DsColors.danger,
    ButtonVariant.black: DsColors.black,
  };

  Color get backgroundColor => _backgroundMap[this] ?? DsColors.primary;
  Color get textColor => DsColors.white;
}
