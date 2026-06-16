import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/navigation/app_routes.dart';
import 'widget/custom_button.dart';
import 'widget/custom_text.dart';

// L-3: Renamed from reset_passowrd_finished_view.dart (typo fixed).
// Class name also corrected: ResetPassowrdFinishedView → ResetPasswordFinishedView.
class ResetPasswordFinishedView extends StatelessWidget {
  const ResetPasswordFinishedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 140),
            Image.asset(AppAssets.correctIcon, width: 98, height: 98),
            const SizedBox(height: 25),
            const CustomText(
              text: 'Password Updated!',
              style: AppTextStyles.nunito32w900Black,
            ),
            const CustomText(
              text: 'You can now sign in with your new password.',
              style: AppTextStyles.nunito14w400Grey,
            ),
            const SizedBox(height: 60),
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
