import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_text.dart';
import 'widget/custom_text_form_field.dart';
import 'reset_password_verify_view.dart';

class ResetPasswordRequestView extends StatefulWidget {
  const ResetPasswordRequestView({super.key});

  @override
  State<ResetPasswordRequestView> createState() =>
      _ResetPasswordRequestViewState();
}

class _ResetPasswordRequestViewState extends State<ResetPasswordRequestView> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
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
                    text: 'Forget Password',
                    style: AppTextStyles.nunito32w900Black,
                  ),
                  const SizedBox(height: 8),
                  const CustomText(
                    text: 'Enter the email address registered with your account. We will send you a code to reset your password.',
                    style: AppTextStyles.nunito14w400Grey,
                  ),
                  const SizedBox(height: 30),
                  const CustomText(
                    text: 'Email Address',
                    style: AppTextStyles.nunito16w900Black,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    isPassword: false,
                    hintText: 'example@gmail.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: 'Submit',
                    onTap: () {
                      if (!formKey.currentState!.validate()) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResetPasswordVerifyView(
                            email: emailController.text.trim(),
                          ),
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