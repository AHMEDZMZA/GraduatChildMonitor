import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultInfoCard extends StatelessWidget {
  const ResultInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 255,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: ColorManager.primaryBlue, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black8,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: title,
              style: AppTextStyles.nunito20w900Black.copyWith(
                color: ColorManager.primaryBlue,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            CustomText(
              text: subtitle,
              style: AppTextStyles.nunito14w400Grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

