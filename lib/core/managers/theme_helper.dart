import 'package:flutter/material.dart';
import 'color_manager.dart';

extension BuildContextExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get scaffoldBackground =>
      isDarkMode ? ColorManager.nearBlack : ColorManager.backgroundWhite;

  Color get cardBackground =>
      isDarkMode ? const Color(0xFF1E1E1E) : ColorManager.white;

  Color get textColor =>
      isDarkMode ? ColorManager.white : ColorManager.darkText;

  Color get secondaryTextColor =>
      isDarkMode ? ColorManager.mediumGray : ColorManager.mediumGray;

  Color get borderColor =>
      isDarkMode ? const Color(0xFF333333) : ColorManager.lightGray;

  Color get dividerColor =>
      isDarkMode ? const Color(0xFF333333) : ColorManager.lightGray;

  Color get inputFillColor =>
      isDarkMode ? const Color(0xFF2A2A2A) : ColorManager.backgroundLight;

  Color get inputBorderColor =>
      isDarkMode ? const Color(0xFF333333) : ColorManager.lightGray;

  Color get disabledColor =>
      isDarkMode ? ColorManager.darkGray : ColorManager.grayB9;
}

class ThemeHelper {
  static Color getBackgroundColor(BuildContext context) =>
      context.scaffoldBackground;

  static Color getCardColor(BuildContext context) => context.cardBackground;

  static Color getTextColor(BuildContext context) => context.textColor;

  static Color getSecondaryTextColor(BuildContext context) =>
      context.secondaryTextColor;

  static Color getBorderColor(BuildContext context) => context.borderColor;

  static Color getInputFillColor(BuildContext context) =>
      context.inputFillColor;

  static Color getInputBorderColor(BuildContext context) =>
      context.inputBorderColor;

  static bool isDarkMode(BuildContext context) => context.isDarkMode;
}
