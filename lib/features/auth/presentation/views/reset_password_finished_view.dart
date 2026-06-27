import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/navigation/app_routes.dart';
import 'widget/custom_button.dart';
import 'widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// L-3: Renamed from reset_passowrd_finished_view.dart (typo fixed).
// Class name also corrected: ResetPassowrdFinishedView → ResetPasswordFinishedView.
class ResetPasswordFinishedView extends StatelessWidget {
  const ResetPasswordFinishedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
              text: 'Password Updated!',
              style: AppTextStyles.nunito32w900Black,
            ),
            CustomText(
              text: 'You can now sign in with your new password.',
              style: AppTextStyles.nunito14w400Grey,
            ),
            SizedBox(height: 60.h),
            CustomButton(
              text: 'Continue to Login',
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
