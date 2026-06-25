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
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Navigate to main app after successful login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.mainNav,
            (route) => false,
          );
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
          //   backgroundColor: ColorManager.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            //   backgroundColor: ColorManager.white,
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        text: 'Sign In',
                        style: AppTextStyles.nunito32w900Black,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // M-5: Social auth section extracted into reusable widget.
                    const SocialAuthSection(dividerLabel: 'or sign in with'),
                    CustomText(
                      text: 'Email Address',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    SizedBox(height: 6.h),
                    CustomTextFormField(
                      isPassword: false,
                      hintText: 'example@gmail.com',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 18.h),
                    CustomText(
                      text: 'Password',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    SizedBox(height: 6.h),
                    CustomTextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscuringCharacter: '*',
                      isPassword: true,
                      hintText: '*******',
                      controller: passwordController,
                    ),
                    SizedBox(height: 18.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.resetPasswordRequest,
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: CustomText(
                          text: 'Forgot Password?',
                          style: AppTextStyles.nunito15w400blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: state is AuthLoading ? 'Loading...' : 'Login',
                          onTap: state is AuthLoading
                              ? () {}
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                                  }
                                },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'Don\'t have an Account? ',
                          color: ColorManager.nearBlack13,
                          fontSize: 14.sp,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.signup);
                          },
                          child: CustomText(
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
      ),
    );
  }
}
