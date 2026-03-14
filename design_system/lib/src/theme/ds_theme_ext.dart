import 'package:flutter/material.dart';
import 'ds_color_tokens.dart';

extension DsThemeContext on BuildContext {
  /// Shortcut to read [DsThemeColors] from the current theme.
  ///
  /// Throws if [DsTheme.light] / [DsTheme.dark] is not set up in [MaterialApp].
  DsThemeColors get dsColors => Theme.of(this).extension<DsThemeColors>()!;
}
