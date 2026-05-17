import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manger.dart';

class AppTextStyles {
  // Nunito Regular Styles
  static const TextStyle nunito12w400Black = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static const TextStyle nunito14w400Grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static const TextStyle nunito14w400Black = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static const TextStyle nunito15w400blue = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
    color: ColorManager.deepAqua,
  );

  static const TextStyle nunito16w400Black = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
  );

  // Nunito SemiBold Styles
  static const TextStyle nunito16w600Black = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: FontConstants.primaryFontFamily,
  );

  // Nunito Bold Styles
  static const TextStyle nunito14w900Black = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static const TextStyle nunito16w900Black = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static const TextStyle nunito18w900Black = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static const TextStyle nunito20w900Black = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static const TextStyle nunito32w900Black = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static const TextStyle nunito30w900Black = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );
  // White color variants
  static const TextStyle nunito16w900White = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
    color: ColorManager.white,
  );

  static const TextStyle nunito14w400White = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
    color: ColorManager.white,
  );

  // Green variants
  static const TextStyle nunito16w900Green = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
    color: ColorManager.primaryBlue,
  );

  // SemiBold variants
  static const TextStyle nunito16w700Black = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static const TextStyle nunito15w900primaryBlue = TextStyle(
    color: ColorManager.primaryBlue,
    fontSize: 15,
    fontFamily: FontConstants.primaryFontFamily,
    fontWeight: FontWeight.w900,
  );
  static const TextStyle nunito12w600overlayGray66 = TextStyle(
    fontSize: 12.5,
    fontFamily: FontConstants.primaryFontFamily,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle notificationDetailsText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: FontConstants.primaryFontFamily,
    height: 1.45,
  );
}
