import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text_form_field.dart';
import '../widgets/profile_top_header.dart';

class PasswordManagerView extends StatefulWidget {
  const PasswordManagerView({super.key});

  @override
  State<PasswordManagerView> createState() => _PasswordManagerViewState();
}

class _PasswordManagerViewState extends State<PasswordManagerView> {
  final TextEditingController currentPasswordController = TextEditingController(
    text: '************',
  );
  final TextEditingController newPasswordController = TextEditingController(
    text: '************',
  );
  final TextEditingController confirmPasswordController = TextEditingController(
    text: '************',
  );

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.backgroundWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileTopHeader(title: 'Password Manager'),
                const SizedBox(height: 34),

                const Text(
                  'Current Password',
                  style: AppTextStyles.nunito16w900Black,
                ),
                const SizedBox(height: 10),

                CustomTextFormField(
                  isPassword: true,
                  hintText: 'Enter current password',
                  controller: currentPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.nunito14w400Grey.copyWith(
                      color: ColorManager.primaryBlue,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'New Password',
                  style: AppTextStyles.nunito16w900Black,
                ),

                const SizedBox(height: 10),

                CustomTextFormField(
                  isPassword: true,
                  hintText: 'Enter new password',
                  controller: newPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                ),

                const SizedBox(height: 18),

                const Text(
                  'Confirm New Password',
                  style: AppTextStyles.nunito16w900Black,
                ),
                const SizedBox(height: 10),

                CustomTextFormField(
                  isPassword: true,
                  hintText: 'Confirm new password',
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                ),

                const SizedBox(height: 60),

                CustomButton(text: 'Change Password', onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
