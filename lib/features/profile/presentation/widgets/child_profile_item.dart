import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChildProfileItem extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const ChildProfileItem({
    super.key,
    required this.name,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            const Icon(
              Icons.person_outline,
              color: ColorManager.primaryBlue,
              size: 24,
            ),
            SizedBox(width: 18.w),
            Expanded(
              child: CustomText(
                text: name,
                style: AppTextStyles.nunito20w900Black.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),
            if (onEdit != null) ...[
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 22,
                  color: ColorManager.primaryBlue,
                ),
                onPressed: onEdit,
              ),
              SizedBox(width: 8.w),
            ],
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: ColorManager.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
