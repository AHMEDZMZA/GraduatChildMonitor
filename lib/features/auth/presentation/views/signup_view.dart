import 'package:child_monitor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:child_monitor_app/features/auth/presentation/state/auth_state.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import 'widget/custom_button.dart';
import 'widget/custom_text.dart';
import 'widget/custom_text_form_field.dart';
import 'widget/social_auth_section.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController monitorNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          // Navigate to login after successful signup
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorManager.errorRed,
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          //        backgroundColor: ColorManager.white,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            //         backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                    // M-5: Social auth section extracted into reusable widget.
                    const SocialAuthSection(dividerLabel: 'or sign up with'),
                    const CustomText(
                      text: 'Monitor Name',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    const SizedBox(height: 6),
                    CustomTextFormField(
                      isPassword: false,
                      hintText: 'Monitor Name',
                      controller: monitorNameController,
                    ),
                    const SizedBox(height: 18),
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
                      obscuringCharacter: '*',
                      isPassword: true,
                      hintText: '*******',
                      controller: passwordController,
                    ),
                    const SizedBox(height: 18),
                    const CustomText(
                      text: 'Confirm Password',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    const SizedBox(height: 7),
                    CustomTextFormField(
                      obscuringCharacter: '*',
                      isPassword: true,
                      hintText: '*******',
                      controller: confirmPasswordController,
                      extraValidator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: state is AuthLoading
                              ? 'Loading...'
                              : 'Register',
                          onTap: state is AuthLoading
                              ? () {}
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().signup(
                                      monitorName: monitorNameController.text
                                          .trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                      confirmPassword:
                                          confirmPasswordController.text,
                                    );
                                  }
                                },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: 'Already have an Account? ',
                          color: ColorManager.nearBlack13,
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
      ),
    );
  }
}
