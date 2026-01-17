import 'package:flutter/material.dart';
import 'package:rastro/ui/theme/colors.dart';

enum ButtonVariant {
  primary,
  danger,
  black,
}

extension ButtonVariantExtension on ButtonVariant {
  static final _backgroundMap = <ButtonVariant, Color>{
    ButtonVariant.primary: AppColors.primary,
    ButtonVariant.danger: AppColors.danger,
    ButtonVariant.black: AppColors.black,
  };

  Color get backgroundColor => _backgroundMap[this] ?? AppColors.primary;
  Color get textColor => AppColors.white;
}
