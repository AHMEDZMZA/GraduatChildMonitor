import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme == 'dark') {
      emit(ThemeMode.dark);
    } else if (savedTheme == 'system') {
      emit(ThemeMode.system);
    } else {
      emit(ThemeMode.light);
    }
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
