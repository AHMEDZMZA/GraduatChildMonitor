import 'package:flutter/material.dart';

class ColorManager {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static final Color white4 = white.withValues(alpha: 0.04);
  static final Color white60 = white.withValues(alpha: 0.60);
  static const Color backgroundWhite = Color(0xFFFAFAFA);
  static const Color backgroundLight = Color(0xFFFDFDFD);
  static const Color backgroundVeryLight = Color(0xFFF8F3F1);
  static const Color backgroundF9 = Color(0xFFF9F8F8);
  static const Color paleCream = Color(0xffEFE2DD);
  static const Color nearWhiteF5FB = Color(0xFFF5FBFf);

  static final Color black8 = black.withValues(alpha: 0.08);
  static const Color nearBlack = Color(0xFF222222);
  static const Color darkText = Color(0xFF212121);
  static const Color darkGray = Color(0xFF333333);

  static const Color mediumGray = Color(0xFF777EA5);
  static const Color softGray = Color(0xFF858EA9);
  static const Color grayB9 = Color(0xFFB9B9B9);
  static const Color grayB0 = Color(0xFFB0B0B0);
  static const Color grayC4 = Color(0xFFC4C4C4);
  static const Color grayCB = Color(0xFFCBCBCB);
  static const Color lightGray = Color(0xFFE2E5EA);
  static final Color lightGray50 = lightGray.withValues(alpha: 0.50);
  static const Color lightGray2 = Color(0xFFD9DADA);
  /// Used in auth screens as the horizontal divider between social and email sign-in.
  static const Color dividerSteel = Color(0xFFCBD2E0);
  /// Near-black used in auth screen account-prompt text.
  static const Color nearBlack13 = Color(0xFF131111);

  static const Color paleGrayCCD8DB = Color(0xFFCCD8DB);
  static const Color paleGrayDCE3DB = Color(0xFFDCE3DB);
  static const Color paleGrayDDDAEC = Color(0xFFDDDAEC);
  static const Color paleGrayE7F8F2 = Color(0xFFE7F8F2);

  static final Color overlayBlack20 = black.withValues(alpha: 0.20);
  static final Color overlayGrayDark12 = const Color(
    0xFF677294,
  ).withValues(alpha: 0.12);
  static final Color overlayGrayMedium12 = const Color(
    0xFF76809F,
  ).withValues(alpha: 0.12);
  static const Color overlayGray66_100 = Color(0xFF666666);
  static const Color overlayGray66 = Color(0xFF475569);
  static const Color primaryBlue = Color(0xFF2563EB);
  static final Color primaryBlue25 = primaryBlue.withValues(alpha: 0.25);
  static final Color primaryBlue50 = primaryBlue.withValues(alpha: 0.50);
  static final Color primaryBlue30 = primaryBlue.withValues(alpha: 0.30);
  static final Color primaryBlue10 = primaryBlue.withValues(alpha: 0.10);
  static final Color primaryGreen8 = primaryBlue.withValues(alpha: 0.08);
  static const Color tealGreen = Color(0xFF29CCB1);
  static const Color darkTeal = Color(0xFF076673);
  static const Color brightTeal = Color(0xFF0EB478);
  static const Color vibrantGreen = Color(0xFF0EB67A);
  static const Color deepTeal = Color(0xFF0F7986);
  static const Color darkForestGreen = Color(0xFF03905E);

  static final Color lightUtilGreen76 = const Color(
    0xFFC6EFE5,
  ).withValues(alpha: 0.76);
  static const Color mutedGreen = Color(0xFFB3E59F);
  static const Color limeGreen = Color(0xFF99D53B);

  static const Color darkNavy = Color(0xFF677294);
  static final Color darkNavy90 = darkNavy.withValues(alpha: 0.90);
  static final Color darkNavy80 = darkNavy.withValues(alpha: 0.80);
  static final Color darkNavy16 = darkNavy.withValues(alpha: 0.16);
  static final Color darkNavy10 = darkNavy.withValues(alpha: 0.10);

  static const Color skyBlue = Color(0xFF61CEFF);
  static const Color buttonBlue = Color(0xFFF4F7FF);
  static final Color skyBlue67 = skyBlue.withValues(alpha: 0.67);
  static final Color skyBlue72 = skyBlue.withValues(alpha: 0.72);
  static const Color blueGray = Color(0xFF5680A6);
  static const Color veryLightBlue = Color(0xFFCBE2FF);
  static const Color lightBlue = Color(0xFF73C3FF);
  static const Color lightBlue99 = Color(0xFF99E6FC);
  static const Color vibrantAqua = Color(0xFF62DBFB);
  static const Color deepAqua = Color(0xFF31A7FB);
  static const Color oceanBlue = Color(0xFF44A4EC);
  static const Color ceruleanBlue = Color(0xFF51BCF9);
  static const Color azureBlue = Color(0xFF64B9FC);
  static const Color lightAqua = Color(0xFF70D9E6);
  static const Color paleBlue = Color(0xFFBED8FB);
  static const Color babyBlue = Color(0xFFD6E8FF);
  static const Color paleBlueF2FB = Color(0xFFF2FBFF);
  static const Color paleBlueDFF6 = Color(0xFFDFF6FD);
  static const Color palePurpleD0CE = Color(0xFFD0CEE7);
  static const Color sloganColor = Color(0xFF1F4571);

  static const Color errorRed = Color(0xFFFF0000);
  static const Color darkAlertRed = Color(0xFFFA002F);
  static const Color alertRedE734 = Color(0xFFE7343F);
  static const Color alertRedFB00 = Color(0xFFFB0000);
  static const Color alertRed4A = Color(0xFFFF4A4A);
  static const Color alertRed48 = Color(0xFFFF484C);
  static const Color alertRed6C = Color(0xFFFF6C60);
  static const Color warningRed = Color(0xFFED4C54);

  static const Color vibrantOrange = Color(0xFFFF5023);
  static const Color brightOrange = Color(0xFFFF6243);

  static const Color gold = Color(0xFFF6D060);
  static const Color goldFFBD = Color(0xFFFFBD86);
  static const Color goldFED2 = Color(0xFFFED2A4);
  static const Color goldFFBB = Color(0xFFFFBB24);
  static const Color goldFEDB = Color(0xFFFEDB56);
  static const Color darkGold = Color(0xFFE9B02C);
  static const Color mustardYellow = Color(0xFFF4C534);
  static const Color brightYellow = Color(0xFFFAD24D);
  static const Color paleOrange = Color(0xFFFFC380);
  static const Color paleYellow = Color(0xFFFFC799);
  static const Color lemonYellow = Color(0xFFFFD93B);

  static RadialGradient _getRadialGradient({required List<Color> colors}) =>
      RadialGradient(radius: .8, colors: colors);

  static LinearGradient _getLinearGradient({
    required List<Color> colors,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) => LinearGradient(colors: colors, begin: begin, end: end);

  static const Color blueGradientStart = Color(0xff2753F3);
  static const Color blueGradientEnd = Color(0xff765AFC);
  static final RadialGradient blueRadialGradient = _getRadialGradient(
    colors: [ceruleanBlue, lightAqua],
  );
  static final LinearGradient blueLinearGradient = _getLinearGradient(
    colors: [blueGradientStart, blueGradientEnd],
  );

  static const Color orangeGradientStart = Color(0xffFE7F44);
  static const Color orangeGradientEnd = Color(0xffFFCF68);
  static final LinearGradient orangeGradient = _getLinearGradient(
    colors: [orangeGradientStart, orangeGradientEnd],
  );

  static const Color redGradientStart = Color(0xffFF484C);
  static const Color redGradientEnd = Color(0xffFF6C60);
  static final LinearGradient redGradient = _getLinearGradient(
    colors: [redGradientStart, redGradientEnd],
  );
}
