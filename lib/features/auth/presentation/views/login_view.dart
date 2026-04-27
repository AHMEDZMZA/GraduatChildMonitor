import 'package:child_monitor_app/features/auth/presentation/views/reset_password_request_view.dart';
import 'package:child_monitor_app/features/auth/presentation/views/signup_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_login_social.dart';
import 'widget/custom_text.dart';
import 'widget/custom_text_form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
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
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          elevation: 0,
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
                      text: 'Sign In',
                      style: AppTextStyles.nunito32w900Black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomLoginSocial(
                    name: AppAssets.googleLogo,
                    text: 'Sign in with Google',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  CustomLoginSocial(
                    name: AppAssets.facebookLogo,
                    text: 'Sign in with Facebook',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFCBD2E0),
                            thickness: 1,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.white,
                          child: const Text(
                            'or sign in with',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.nunito14w400Grey,
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFCBD2E0),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 11),
                  const CustomText(
                    text: 'Email Address',
                    style: AppTextStyles.nunito16w900Black,
                  ),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    isPassword: false,
                    hintText: 'example@gmail.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),
                  const CustomText(
                    text: 'Password',
                    style: AppTextStyles.nunito16w900Black,
                  ),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscuringCharacter: '*',
                    isPassword: true,
                    hintText: '*******',
                    controller: passwordController,
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordRequestView(),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: const CustomText(
                        text: 'Forgot Password?',
                        style: AppTextStyles.nunito15w400blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    text: 'Login',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        // Navigator.pushNamedAndRemoveUntil(
                        //   context,
                        //   AppRoutes.addChild,
                        //   (route) => false,
                        // );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: 'Don\'t have an Account? ',
                        color: Color(0xFF131111),
                        fontSize: 14,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupView(),
                            ),
                          );
                        },
                        child: const CustomText(
                          text: 'Sign up',
                          style: AppTextStyles.nunito15w400blue,
                        ),
                      ),
                    ],
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
