import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum ToastVariant {
  success,
  warning,
  error,
  info,
}

extension ToastVariantExtension on ToastVariant {
  static final _colorMap = <ToastVariant, Color>{
    ToastVariant.success: DsColors.success,
    ToastVariant.warning: DsColors.warning,
    ToastVariant.error: DsColors.danger,
    ToastVariant.info: DsColors.primary,
  };

  static final _iconMap = <ToastVariant, IconData>{
    ToastVariant.success: Icons.check_circle_rounded,
    ToastVariant.warning: Icons.warning_amber_rounded,
    ToastVariant.error: Icons.error,
    ToastVariant.info: Icons.info,
  };

  Color get color => _colorMap[this] ?? DsColors.primary;
  IconData get icon => _iconMap[this] ?? Icons.info;
}
