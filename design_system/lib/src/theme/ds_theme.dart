import 'package:flutter/material.dart';
import 'ds_colors.dart';
import 'ds_color_tokens.dart';
import 'ds_typography.dart';

/// Central theme factory.
///
/// Usage in your app:
/// ```dart
/// MaterialApp(
///   theme: DsTheme.light,
///   darkTheme: DsTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```
class DsTheme {
  DsTheme._();

  static ThemeData get light => _build(
        tokens: DsThemeColors.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: DsColors.primary,
          brightness: Brightness.light,
        ),
      );

  static ThemeData get dark => _build(
        tokens: DsThemeColors.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: DsColors.primary,
          brightness: Brightness.dark,
        ),
      );

  static ThemeData _build({
    required DsThemeColors tokens,
    required ColorScheme colorScheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.background,
      extensions: [tokens],
      textTheme: _textTheme(),
    );
  }

  static TextTheme _textTheme() {
    return TextTheme(
      displayLarge: DsTypography.headline,
      titleLarge: DsTypography.title,
      titleMedium: DsTypography.subtitle,
      bodyMedium: DsTypography.body,
      labelMedium: DsTypography.label,
      bodySmall: DsTypography.caption,
    );
  }
}
