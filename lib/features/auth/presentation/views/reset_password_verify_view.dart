import 'package:child_monitor_app/features/auth/presentation/views/reset_password_confirm_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_pin_code_fields.dart';
import 'widget/custom_text.dart';

class ResetPasswordVerifyView extends StatefulWidget {
  final String email;

  const ResetPasswordVerifyView({super.key, required this.email});

  @override
  State<ResetPasswordVerifyView> createState() =>
      _ResetPasswordVerifyViewState();
}

class _ResetPasswordVerifyViewState extends State<ResetPasswordVerifyView> {
  final TextEditingController otpController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    otpController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Verify Your Account',
                  style: AppTextStyles.nunito32w900Black,
                ),
                const SizedBox(height: 8),
                const CustomText(
                  text: 'We\'ve sent a code to your email, please enter the code below.',
                  style: AppTextStyles.nunito14w400Grey,
                ),
                const SizedBox(height: 40),
                const Text('Enter Code', style: AppTextStyles.nunito16w700Black),
                const SizedBox(height: 15),
                CustomPinCodeFields(controller: otpController),
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Submit',
                  onTap: () {
                    if (otpController.text.isEmpty || otpController.text.length < 6) {
                      setState(() {
                        errorMessage = 'Please enter the 6-digit code sent to your email.';
                      });
                    } else {
                      setState(() => errorMessage = null);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResetPasswordConfirmView(
                            email: widget.email,
                            otp: otpController.text.trim(),
                          ),
                        ),
                      );
                      // Navigator.pushNamed(
                      //   context,
                      //   AppRoutes.resetPasswordConfirm,
                      //   arguments: {
                      //     'email': widget.email,
                      //     'otp': otpController.text.trim(),
                      //   },
                      // );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}