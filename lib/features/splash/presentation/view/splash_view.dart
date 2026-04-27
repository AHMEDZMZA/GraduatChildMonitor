import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/glow_blur_circle.dart';
import '../../../onboarding/presentation/view/onboarding_view.dart';

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

  void _navigateAfterDelay() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorManager.grayB9, Colors.white],
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
                const SizedBox(height: 20),
                // Text(
                //   AppStrings.appName,
                //   style: getBoldtStyle(
                //     color: ColorManager.primaryBlue,
                //     fontSize: 28,
                //   ),
                // ),
                const SizedBox(height: 10),
                // Text(
                //   AppStrings.appSlogan,
                //   style: getRegularStyle(
                //     color: ColorManager.sloganColor,
                //     fontSize: 20,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
