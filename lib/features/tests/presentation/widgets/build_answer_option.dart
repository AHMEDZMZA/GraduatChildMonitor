import 'package:flutter/material.dart';

import '../../../../core/managers/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: selected ? ColorManager.primaryBlue : ColorManager.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? ColorManager.primaryBlue : ColorManager.lightGray,
            width: 1.5,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: ColorManager.primaryBlue25,
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? ColorManager.white
                      : ColorManager.mediumGray,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Center(
                      child: Icon(Icons.circle, size: 10, color: Colors.white),
                    )
                  : null,
            ),
            SizedBox(width: 10.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: selected ? ColorManager.white : ColorManager.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
