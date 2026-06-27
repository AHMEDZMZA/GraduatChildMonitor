import 'package:easy_localization/easy_localization.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';

import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../home/presentation/widgets/result_info_card.dart';
import 'package:child_monitor_app/features/quiz/domain/entities/quiz_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultQuizView extends StatelessWidget {
  const ResultQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the result from arguments
    final result =
        ModalRoute.of(context)?.settings.arguments as QuizResultEntity?;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
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

              SizedBox(height: 24.h),

              CustomText(
                text:
                    result?.message ??
                    'Your answers have been\n successfully analyzed.',
                style: AppTextStyles.nunito30w900Black,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomText(
                  text: 'based_on_answers'.tr(),
                  style: AppTextStyles.nunito14w400Grey,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 34.h),

              ResultInfoCard(
                title: '${'score'.tr()}: ${result?.score ?? 0}',
                subtitle: result?.feedback ?? 'No feedback provided.',
              ),

              SizedBox(height: 90.h),

              CustomButton(
                text: 'ok'.tr(),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.todayPlan,
                    (route) => route.isFirst,
                  );
                },
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

