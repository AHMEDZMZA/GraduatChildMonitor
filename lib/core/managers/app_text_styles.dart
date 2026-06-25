import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppTextStyles {
  // Nunito Regular Styles
  static final TextStyle nunito12w400Black = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static final TextStyle nunito14w400Grey = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static final TextStyle nunito14w400Black = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static final TextStyle nunito15w400blue = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
    color: ColorManager.deepAqua,
  );

  static final TextStyle nunito16w400Black = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
  );

  // Nunito SemiBold Styles
  static final TextStyle nunito16w600Black = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: FontConstants.primaryFontFamily,
  );

  // Nunito Bold Styles
  static final TextStyle nunito14w900Black = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static final TextStyle nunito16w900Black = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static final TextStyle nunito18w900Black = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static final TextStyle nunito20w900Black = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static final TextStyle nunito32w900Black = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static final TextStyle nunito30w900Black = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
  );
  // White color variants
  static final TextStyle nunito16w900White = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
    color: ColorManager.white,
  );

  static final TextStyle nunito14w400White = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontConstants.primaryFontFamily,
    color: ColorManager.white,
  );

  // Green variants
  static final TextStyle nunito16w900Green = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w900,
    fontFamily: FontConstants.primaryFontFamily,
    color: ColorManager.primaryBlue,
  );

  // SemiBold variants
  static final TextStyle nunito16w700Black = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    fontFamily: FontConstants.primaryFontFamily,
  );

  static final TextStyle nunito15w900primaryBlue = TextStyle(
    color: ColorManager.primaryBlue,
    fontSize: 15.sp,
    fontFamily: FontConstants.primaryFontFamily,
    fontWeight: FontWeight.w900,
  );
  static final TextStyle nunito12w600overlayGray66 = TextStyle(
    fontSize: 12.5.sp,
    fontFamily: FontConstants.primaryFontFamily,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle notificationDetailsText = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: FontConstants.primaryFontFamily,
    height: 1.45,
  );
}
