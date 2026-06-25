import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCardQuiz extends StatelessWidget {
  const InfoCardQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 306,
      height: 257,
      alignment: Alignment.center,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: 'Focus Quiz',
            style: AppTextStyles.nunito30w900Black.copyWith(fontSize: 28.sp),
          ),
          SizedBox(height: 40.h),
           CustomText(
             text:
                 'This quiz includes 3 simple\n'
                 ' questions designed to support\n'
                 ' learning and focus.',
             style: AppTextStyles.nunito20w900Black.copyWith(
               color: ColorManager.primaryBlue,
             ),
           ),
        ],
      ),
    );
  }
}
