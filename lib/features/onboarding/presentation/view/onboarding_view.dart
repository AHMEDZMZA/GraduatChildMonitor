import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/glow_blur_circle.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: _OnboardingContent()));
  }
}

class _OnboardingContent extends StatefulWidget {
  const _OnboardingContent();

  @override
  State<_OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<_OnboardingContent> {
  final PageController _controller = PageController();
  int _index = 0;

  final pages = [
    const _OnboardingStep(
      onboardingSvgPath: AppAssets.firstOnboarding,
      title: AppStrings.firstOnBoardingTitle,
      subtitle: AppStrings.firstOnBoardingSubTitle,
    ),
    const _OnboardingStep(
      onboardingSvgPath: AppAssets.secondOnboarding,
      title: AppStrings.secondOnBoardingTitle,
      subtitle: AppStrings.secondOnBoardingSubTitle,
    ),
    const _OnboardingStep(
      onboardingSvgPath: AppAssets.thirdOnboarding,
      title: AppStrings.thirdOnBoardingTitle,
      subtitle: AppStrings.thirdOnBoardingSubTitle,
    ),
  ];

  void _goToLogin(BuildContext context) async {
    // Save onboarding flag
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double? leftPosition = (_index == 1) ? null : -100;
    final double? rightPosition = (_index == 1) ? -100 : null;

    return Stack(
      children: [
        GlowBlurCircle(
          width: 342,
          height: 342,
          gradient: ColorManager.blueRadialGradient,
          top: -50,
          left: leftPosition,
          right: rightPosition,
          isBlurred: false,
        ),
        GlowBlurCircle(
          width: 216,
          height: 216,
          gradient: ColorManager.blueRadialGradient,
          bottom: -80,
          right: -120,
        ),
        Column(
          children: [
            SizedBox(height: 100.h),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) {
                  setState(() => _index = i);
                },
                itemBuilder: (_, i) => pages[i],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _goToLogin(context),
                    child: Text(
                      AppStrings.skip,
                      style: TextStyle(
                        color: ColorManager.mediumGray,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _index == i
                              ? ColorManager.primaryBlue
                              : ColorManager.lightGray,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_index < pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _goToLogin(context);
                      }
                    },
                    child: Text(
                      AppStrings.next,
                      style: TextStyle(
                        color: ColorManager.primaryBlue,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_index > 0)
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                _controller.previousPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: ColorManager.white,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: ColorManager.darkText,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  final String onboardingSvgPath;
  final String title;
  final String subtitle;

  const _OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.onboardingSvgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.0.r),
      child: Column(
        children: [
          ClipOval(
            child: SizedBox(
              width: 336,
              height: 336,
              child: Image.asset(onboardingSvgPath, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 40.h),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: ColorManager.mediumGray),
          ),
        ],
      ),
    );
  }
}
