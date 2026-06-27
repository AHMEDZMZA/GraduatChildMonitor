import 'package:easy_localization/easy_localization.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../widgets/info_card_quiz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InteractiveQuizTodayView extends StatelessWidget {
  final String? childId;

  const InteractiveQuizTodayView({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    // Get childId from arguments if not provided
    String? passedChildId =
        childId ?? ModalRoute.of(context)?.settings.arguments as String?;

    if (passedChildId == null) {
      try {
        final homeState = context.read<HomeCubit>().state;
        if (homeState is HomeSuccess) {
          passedChildId = homeState.homeData.selectedChildId ??
              (homeState.homeData.children.isNotEmpty
                  ? homeState.homeData.children.first.id
                  : null);
        }
      } catch (_) {}
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    backgroundColor: ColorManager.buttonBlue,
                    radius: 20,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 60.h),

              CustomText(
                text: 'interactive_quizzes'.tr(),
                style: AppTextStyles.nunito30w900Black.copyWith(fontSize: 28.sp),
              ),

              SizedBox(height: 10.h),

              CustomText(
                text:
                    'A short quiz to help your child learn through fun and simple questions.',
                style: AppTextStyles.nunito14w400Grey,
              ),

              SizedBox(height: 42.h),

              const Center(child: InfoCardQuiz()),

              SizedBox(height: 80.h),

              CustomButton(
                text: 'start_quiz'.tr(),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.testQuiz,
                    arguments: passedChildId,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

