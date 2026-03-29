import 'package:flutter/material.dart';
import 'ds_colors.dart';

/// Semantic color tokens that adapt to light / dark mode.
/// Access them via [BuildContext.dsColors] from `ds_theme_ext.dart`.
class DsThemeColors extends ThemeExtension<DsThemeColors> {
  const DsThemeColors({
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.border,
    required this.muted,
  });

  /// Card backgrounds, sheets, nav bars.
  final Color surface;

  /// Text / icons placed on top of [surface].
  final Color onSurface;

  /// Scaffold / page background.
  final Color background;

  /// Text / icons placed on top of [background].
  final Color onBackground;

  /// Input borders and dividers.
  final Color border;

  /// Captions, hints, and secondary icons.
  final Color muted;

  static const light = DsThemeColors(
    surface: DsColors.white,
    onSurface: DsColors.black,
    background: DsColors.surface,
    onBackground: DsColors.black,
    border: DsColors.zinc300,
    muted: DsColors.zinc500,
  );

  static const dark = DsThemeColors(
    surface: DsColors.zinc800,
    onSurface: DsColors.zinc50,
    background: DsColors.zinc900,
    onBackground: DsColors.zinc50,
    border: DsColors.zinc700,
    muted: DsColors.zinc400,
  );

  @override
  DsThemeColors copyWith({
    Color? surface,
    Color? onSurface,
    Color? background,
    Color? onBackground,
    Color? border,
    Color? muted,
  }) {
    return DsThemeColors(
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      border: border ?? this.border,
      muted: muted ?? this.muted,
    );
  }

  @override
  DsThemeColors lerp(DsThemeColors? other, double t) {
    if (other is! DsThemeColors) return this;
    return DsThemeColors(
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      border: Color.lerp(border, other.border, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
    );
  }
}
