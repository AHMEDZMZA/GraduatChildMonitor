import 'package:child_monitor_app/features/auth/presentation/views/reset_passowrd_finished_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_text.dart';
import 'widget/custom_text_form_field.dart';

class ResetPasswordConfirmView extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordConfirmView({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordConfirmView> createState() =>
      _ResetPasswordConfirmViewState();
}

class _ResetPasswordConfirmViewState extends State<ResetPasswordConfirmView> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const CustomText(
                    text: 'Reset Password',
                    style: AppTextStyles.nunito32w900Black,
                  ),
                  const SizedBox(height: 8),
                  const CustomText(
                    text: 'Make sure your new password is strong and easy to remember.',
                    style: AppTextStyles.nunito14w400Grey,
                  ),
                  const SizedBox(height: 30),
                  const CustomText(text: 'New Password', style: AppTextStyles.nunito16w900Black),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    isPassword: true,
                    hintText: '********',
                    obscuringCharacter: '*',
                    controller: passwordController,
                  ),
                  const SizedBox(height: 15),
                  const CustomText(text: 'Confirm New Password', style: AppTextStyles.nunito16w900Black),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    isPassword: true,
                    hintText: '********',
                    obscuringCharacter: '*',
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(height: 90),
                  CustomButton(
                    text: 'Update Password',
                    onTap: () {
                      if (!formKey.currentState!.validate()) return;
                      if (passwordController.text != confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResetPassowrdFinishedView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}