import 'package:easy_localization/easy_localization.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../widgets/progress_tracker_info_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressTrackerView extends StatelessWidget {
  final ChildProfileEntity child;

  const ProgressTrackerView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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
                text: 'monthly_assessment_time'.tr(),
                style: AppTextStyles.nunito30w900Black.copyWith(fontSize: 28.sp),
              ),

              SizedBox(height: 10.h),

              CustomText(
                text:
                    'It’s time for the monthly follow-up to track your child’s progress over the past period.',
                style: AppTextStyles.nunito14w400Grey,
              ),

              SizedBox(height: 42.h),

              const Center(child: ProgressTrackerInfoCard()),

              SizedBox(height: 80.h),

              CustomButton(text: 'start_test'.tr(), onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.progressTest,
                  arguments: child,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

