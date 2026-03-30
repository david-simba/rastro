import 'package:flutter/material.dart';
import '../../theme/ds_colors.dart';

enum ToastVariant {
  success,
  warning,
  error,
  info,
}

extension ToastVariantExtension on ToastVariant {
  static final _colorMap = <ToastVariant, Color>{
    ToastVariant.success: DsColors.green500,
    ToastVariant.warning: DsColors.yellow400,
    ToastVariant.error: DsColors.orange500,
    ToastVariant.info: DsColors.blue500,
  };

  static final _iconMap = <ToastVariant, IconData>{
    ToastVariant.success: Icons.check_circle_rounded,
    ToastVariant.warning: Icons.warning_amber_rounded,
    ToastVariant.error: Icons.error,
    ToastVariant.info: Icons.info,
  };

  Color get color => _colorMap[this] ?? DsColors.blue500;
  IconData get icon => _iconMap[this] ?? Icons.info;
}
