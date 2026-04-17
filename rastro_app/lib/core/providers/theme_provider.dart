import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  SharedPreferences? _prefs;

  @override
  ThemeMode build() => ThemeMode.system;

  Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
    final stored = prefs.getString(_key);
    if (stored != null) state = _fromString(stored);
  }

  void setMode(ThemeMode mode) {
    state = mode;
    _prefs?.setString(_key, _toString(mode));
  }

  static ThemeMode _fromString(String s) => switch (s) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  static String _toString(ThemeMode m) => switch (m) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        _ => 'system',
      };
}
