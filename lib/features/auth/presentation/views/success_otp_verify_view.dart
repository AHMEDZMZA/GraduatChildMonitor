import 'package:easy_localization/easy_localization.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessOtpVerifyView extends StatelessWidget {
  const SuccessOtpVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: Column(
          children: [
            SizedBox(height: 140.h),
            Image.asset(AppAssets.correctIcon, width: 98, height: 98),
            SizedBox(height: 25.h),
            CustomText(
              text: 'verification_successful'.tr(),
              style: AppTextStyles.nunito32w900Black,
            ),
            CustomText(
              text: 'account_verified'.tr(),
              style: AppTextStyles.nunito14w400Grey,
            ),
            SizedBox(height: 60.h),
            CustomButton(
              text: 'Change Password',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

