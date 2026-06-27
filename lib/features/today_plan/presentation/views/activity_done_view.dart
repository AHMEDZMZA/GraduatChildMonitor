import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';

import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityDoneView extends StatelessWidget {
  final String title;
  final String image;
  final void Function()? onTap;
  const ActivityDoneView({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 0.h),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Image.asset(AppAssets.correctIcon, width: 98, height: 98),

              SizedBox(height: 18.h),
              Text(
                'Activity Completed!',
                style: AppTextStyles.nunito32w900Black,
              ),
              SizedBox(height: 6.h),
              Text(
                'Great job! You and your child completed this activity\n successfully.',
                textAlign: TextAlign.center,
                style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                title,
                style: AppTextStyles.nunito15w900primaryBlue.copyWith(
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Duration: 10 minutes\nGoal: Help your child express emotions and\n feel emotionally supported.',
                textAlign: TextAlign.center,
                style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                  fontSize: 16.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 30.h),
              CustomButton(
                text: 'start_next_activity'.tr(),
                onTap: () {
                  Navigator.pop(context, true);
                },
              ),
              SizedBox(height: 30.h),
              CustomButton(
                text: 'back_to_home'.tr(),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.mainNav,
                    (route) => false,
                  );
                },
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}

