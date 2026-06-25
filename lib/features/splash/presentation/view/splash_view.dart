import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/glow_blur_circle.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/token_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // H-2: SharedPreferences resolved via DI — no direct getInstance() call.
    final prefs = getIt<SharedPreferences>();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!hasSeenOnboarding) {
      // Show onboarding
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    } else {
      // Onboarding was seen, check for token
      final tokenStorage = getIt<TokenStorage>();
      final hasToken = await tokenStorage.isTokenAvailable();

      if (!mounted) return;

      if (hasToken) {
        // Token exists, navigate to main app
        Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
      } else {
        // No token, navigate to login
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorManager.grayB9, ColorManager.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          GlowBlurCircle(
            width: 260,
            height: 260,
            gradient: ColorManager.blueRadialGradient,
            blurSigma: 80,
            glowBlur: 130,
            top: -120,
            left: -120,
          ),
          GlowBlurCircle(
            width: 260,
            height: 260,
            gradient: ColorManager.blueRadialGradient,
            blurSigma: 80,
            glowBlur: 130,
            bottom: -120,
            right: -120,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.logo),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
