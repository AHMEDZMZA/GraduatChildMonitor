import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';

import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../../core/network/api_client.dart';
import '../widgets/result_info_card.dart';
import '../../../../core/navigation/app_routes.dart';

class ResultProgressView extends StatelessWidget {
  final SubmitMonthlyAssessmentResponse response;
  final ChildProfileEntity child;

  const ResultProgressView({
    super.key,
    required this.response,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            children: [
              const Spacer(flex: 2),

              Image.asset(
                AppAssets.resultTest,
                width: 78,
                height: 78,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 24),

              const CustomText(
                text: 'Your answers have been\nanalyzed successfully.',
                style: AppTextStyles.nunito30w900Black,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Based on your answers, we noticed...',
                  style: AppTextStyles.nunito14w400Grey,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 34),

              ResultInfoCard(
                title: response.trendLabel.isNotEmpty
                    ? response.trendLabel
                    : 'Noticeable improvement in condition',
                subtitle: response.interpretation.isNotEmpty
                    ? response.interpretation
                    : response.message,
              ),

              const Spacer(flex: 3),

              CustomButton(
                text: 'Ok',
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.monthlyProgress,
                    arguments: child,
                  );
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
