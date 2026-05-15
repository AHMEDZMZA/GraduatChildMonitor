import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_text.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 140),
            Image.asset(AppAssets.correctIcon, width: 98, height: 98),
            const SizedBox(height: 25),
            const CustomText(
              text: 'Verification Successful',
              style: AppTextStyles.nunito32w900Black,
            ),
            const CustomText(
              text: 'Your account has been verified. Let’s continue.',
              style: AppTextStyles.nunito14w400Grey,
            ),
            const SizedBox(height: 60),
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
