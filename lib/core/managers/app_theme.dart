import 'package:flutter/material.dart';
import 'color_manager.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _lightPrimary = ColorManager.primaryBlue;
  static const Color _lightScaffold = ColorManager.backgroundWhite;
  static const Color _lightText = ColorManager.darkText;
  static const Color _lightSecondaryText = ColorManager.mediumGray;
  static const Color _lightCardBg = ColorManager.white;
  static const Color _lightBorder = ColorManager.lightGray;

  // Dark Theme Colors
  static const Color _darkPrimary = ColorManager.primaryBlue;
  static const Color _darkScaffold = ColorManager.nearBlack;
  static const Color _darkText = ColorManager.backgroundWhite;
  static const Color _darkSecondaryText = ColorManager.mediumGray;
  static const Color _darkCardBg = Color(0xFF1E1E1E);
  static const Color _darkBorder = Color(0xFF333333);

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: _lightPrimary,
      scaffoldBackgroundColor: _lightScaffold,
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        surface: _lightCardBg,
        onSurface: _lightText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightScaffold,
        foregroundColor: _lightText,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: _lightCardBg,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorManager.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
        hintStyle: TextStyle(color: _lightSecondaryText),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: _lightText),
        displayMedium: TextStyle(color: _lightText),
        displaySmall: TextStyle(color: _lightText),
        headlineLarge: TextStyle(color: _lightText),
        headlineMedium: TextStyle(color: _lightText),
        headlineSmall: TextStyle(color: _lightText),
        titleLarge: TextStyle(color: _lightText),
        titleMedium: TextStyle(color: _lightText),
        titleSmall: TextStyle(color: _lightText),
        bodyLarge: TextStyle(color: _lightText),
        bodyMedium: TextStyle(color: _lightText),
        bodySmall: TextStyle(color: _lightSecondaryText),
        labelLarge: TextStyle(color: _lightText),
        labelMedium: TextStyle(color: _lightText),
        labelSmall: TextStyle(color: _lightSecondaryText),
      ),
      iconTheme: const IconThemeData(color: _lightText),
      dividerColor: _lightBorder,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _lightPrimary;
          }
          return ColorManager.lightGray;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _lightPrimary.withValues(alpha: 0.5);
          }
          return ColorManager.lightGray;
        }),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: _darkPrimary,
      scaffoldBackgroundColor: _darkScaffold,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        surface: _darkCardBg,
        onSurface: _darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkScaffold,
        foregroundColor: _darkText,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: _darkCardBg,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        hintStyle: TextStyle(color: _darkSecondaryText),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: _darkText),
        displayMedium: TextStyle(color: _darkText),
        displaySmall: TextStyle(color: _darkText),
        headlineLarge: TextStyle(color: _darkText),
        headlineMedium: TextStyle(color: _darkText),
        headlineSmall: TextStyle(color: _darkText),
        titleLarge: TextStyle(color: _darkText),
        titleMedium: TextStyle(color: _darkText),
        titleSmall: TextStyle(color: _darkText),
        bodyLarge: TextStyle(color: _darkText),
        bodyMedium: TextStyle(color: _darkText),
        bodySmall: TextStyle(color: _darkSecondaryText),
        labelLarge: TextStyle(color: _darkText),
        labelMedium: TextStyle(color: _darkText),
        labelSmall: TextStyle(color: _darkSecondaryText),
      ),
      iconTheme: const IconThemeData(color: _darkText),
      dividerColor: _darkBorder,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkPrimary;
          }
          return ColorManager.darkGray;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkPrimary.withValues(alpha: 0.5);
          }
          return ColorManager.darkGray;
        }),
      ),
    );
  }
}
