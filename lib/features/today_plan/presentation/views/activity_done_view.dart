import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../bottom_nav/presentation/views/app_bottom_nav_view.dart';

class ActivityDoneView extends StatelessWidget {
  final String title;
  final String image;
  final void Function()? onTap;
  const ActivityDoneView({
    super.key,
    required this.title,
    required this.image, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset(AppAssets.correctIcon, width: 98, height: 98),

              const SizedBox(height: 18),
              const Text(
                'Activity Completed!',
                style: AppTextStyles.nunito32w900Black,
              ),
              const SizedBox(height: 6),
              Text(
                'Great job! You and your child completed this activity\n successfully.',
                textAlign: TextAlign.center,
                style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTextStyles.nunito15w900primaryBlue.copyWith(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Duration: 10 minutes\nGoal: Help your child express emotions and\n feel emotionally supported.',
                textAlign: TextAlign.center,
                style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Start Next Activity',
                onTap: (){
                  Navigator.pop(context, true);
                }
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Back to Home',
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppBottomNavBarView(),
                    ),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}