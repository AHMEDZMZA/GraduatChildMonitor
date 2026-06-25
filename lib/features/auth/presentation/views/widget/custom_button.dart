import 'package:flutter/material.dart';

import '../../../../../core/managers/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.onTap});

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: ColorManager.primaryBlue,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: ColorManager.white,
              fontFamily: 'Nunito',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonSmallTest extends StatelessWidget {
  const CustomButtonSmallTest({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104,
        height: 46,
        decoration: BoxDecoration(
          color: ColorManager.primaryBlue,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: ColorManager.white,
              fontSize: 20.sp,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
