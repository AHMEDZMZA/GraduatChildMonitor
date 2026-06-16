import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  /// M-1 Fix: Initial state is resolved synchronously from SharedPreferences
  /// so only ONE state is emitted at construction \u2014 no redundant double-emit.
  ThemeCubit(this._prefs) : super(_resolveInitialTheme(_prefs));

  static ThemeMode _resolveInitialTheme(SharedPreferences prefs) {
    final saved = prefs.getString(_themeKey);
    if (saved == 'dark') return ThemeMode.dark;
    if (saved == 'system') return ThemeMode.system;
    return ThemeMode.light;
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setTheme(newMode);
  }

  void setTheme(ThemeMode mode) {
    final themeString =
        mode == ThemeMode.dark
            ? 'dark'
            : mode == ThemeMode.system
            ? 'system'
            : 'light';
    _prefs.setString(_themeKey, themeString);
    emit(mode);
  }
}
