import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressTrackerInfoCard extends StatelessWidget {
  const ProgressTrackerInfoCard({super.key});

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
      child: Center(
        child: CustomText(
          text:
              'This assessment is short\n'
              'and simple, and consists of\n'
              'only 5 questions.\n'
              'Your answers help us\n'
              'understand your child’s progress\n'
              'and provide better support.',
          style: AppTextStyles.nunito20w900Black,
        ),
      ),
    );
  }
}
