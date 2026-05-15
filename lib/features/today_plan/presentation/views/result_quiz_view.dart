import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../home/presentation/widgets/result_info_card.dart';

class ResultQuizView extends StatelessWidget {
  const ResultQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.resultTest,
                width: 78,
                height: 78,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 24),

              const CustomText(
                text: 'Your answers have been\n successfully analyzed.',
                style: AppTextStyles.nunito30w900Black,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Based on your answers, here’s what we found',
                  style: AppTextStyles.nunito14w400Grey,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 34),

              const ResultInfoCard(
                title: 'Possible Attention & Focus \nDifficulties',
                subtitle:
                    'Your child may show signs of difficulty with attention\n'
                    'Difficulty staying focused on tasks\n'
                    'Easily distracted by surroundings\n'
                    'Needs frequent reminders',
              ),

              const SizedBox(height: 90),

              CustomButton(
                text: 'Ok',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.todayPlan, (route) => route.isFirst);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
