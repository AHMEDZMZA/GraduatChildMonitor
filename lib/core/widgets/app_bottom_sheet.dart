import 'package:flutter/material.dart';
import '../managers/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final VoidCallback onConfirm;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ColorManager.nearBlack,
            ),
          ),

          SizedBox(height: 14.h),
          const Divider(color: ColorManager.grayB0, thickness: 1),

          /// Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: ColorManager.grayB0),
          ),

          SizedBox(height: 22.h),

          /// Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryBlue10,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: ColorManager.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              /// Confirm
              Expanded(
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryBlue,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: TextButton(
                    onPressed: onConfirm,
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        color: ColorManager.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
