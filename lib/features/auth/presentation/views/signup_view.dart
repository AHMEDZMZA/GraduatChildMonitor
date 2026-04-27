import 'package:child_monitor_app/features/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_login_social.dart';
import 'widget/custom_text.dart';
import 'widget/custom_text_form_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController monitorNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    monitorNameController.dispose();
    emailController.dispose();
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
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CustomText(
                      text: 'Sign Up',
                      style: AppTextStyles.nunito32w900Black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomLoginSocial(
                    name: AppAssets.googleLogo,
                    text: 'Sign up with Google',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  CustomLoginSocial(
                    name: AppAssets.facebookLogo,
                    text: 'Sign up with Facebook',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFCBD2E0), thickness: 1),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.white,
                          child: const Text(
                            'or sign up with',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.nunito14w400Grey,
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFCBD2E0), thickness: 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const CustomText(text: 'Monitor Name', style: AppTextStyles.nunito16w900Black),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    isPassword: false,
                    hintText: 'Monitor Name',
                    controller: monitorNameController,
                  ),
                  const SizedBox(height: 18),
                  const CustomText(text: 'Email Address', style: AppTextStyles.nunito16w900Black),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    isPassword: false,
                    hintText: 'example@gmail.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),
                  const CustomText(text: 'Password', style: AppTextStyles.nunito16w900Black),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    obscuringCharacter: '*',
                    isPassword: true,
                    hintText: '*******',
                    controller: passwordController,
                  ),
                  const SizedBox(height: 18),
                  const CustomText(text: 'Confirm Password', style: AppTextStyles.nunito16w900Black),
                  const SizedBox(height: 7),
                  CustomTextFormField(
                    obscuringCharacter: '*',
                    isPassword: true,
                    hintText: '*******',
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Register',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
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
                            builder: (context) => const LoginView(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: 'Already have an Account? ',
                        color: Color(0xFF131111),
                        fontSize: 14,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CustomText(
                          text: 'Sign in',
                          style: AppTextStyles.nunito15w400blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}