import 'package:flutter/material.dart';
import 'package:rastro/ui/theme/colors.dart';

enum ToastVariant {
  success,
  warning,
  error,
  info,
}

extension ToastVariantExtension on ToastVariant {
  static final _colorMap = <ToastVariant, Color>{
    ToastVariant.success: AppColors.success,
    ToastVariant.warning: AppColors.warning,
    ToastVariant.error: AppColors.danger,
    ToastVariant.info: AppColors.primary,
  };

  static final _iconMap = <ToastVariant, IconData>{
    ToastVariant.success: Icons.check_circle_rounded,
    ToastVariant.warning: Icons.warning_amber_rounded,
    ToastVariant.error: Icons.error,
    ToastVariant.info: Icons.info,
  };

  Color get color => _colorMap[this] ?? AppColors.primary;
  IconData get icon => _iconMap[this] ?? Icons.info;
}