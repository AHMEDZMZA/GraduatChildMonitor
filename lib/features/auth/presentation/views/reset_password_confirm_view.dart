import 'package:child_monitor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:child_monitor_app/features/auth/presentation/state/auth_state.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_text.dart';
import 'widget/custom_text_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess) {
          Navigator.pushNamed(context, AppRoutes.resetPasswordFinished);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: GestureDetector(
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
              padding:
                  EdgeInsets.symmetric(horizontal: 25.w, vertical: 50.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100.h),
                    CustomText(
                      text: 'Reset Password',
                      style: AppTextStyles.nunito32w900Black,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text:
                          'Make sure your new password is strong and easy to remember.',
                      style: AppTextStyles.nunito14w400Grey,
                    ),
                    SizedBox(height: 30.h),
                    CustomText(
                        text: 'New Password',
                        style: AppTextStyles.nunito16w900Black),
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      isPassword: true,
                      hintText: '********',
                      obscuringCharacter: '*',
                      controller: passwordController,
                    ),
                    SizedBox(height: 15.h),
                    CustomText(
                        text: 'Confirm New Password',
                        style: AppTextStyles.nunito16w900Black),
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      isPassword: true,
                      hintText: '********',
                      obscuringCharacter: '*',
                      controller: confirmPasswordController,
                    ),
                    SizedBox(height: 90.h),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: state is AuthLoading
                              ? 'Updating...'
                              : 'Update Password',
                          onTap: state is AuthLoading
                              ? () {}
                              : () {
                                  if (!formKey.currentState!.validate()) return;
                                  if (passwordController.text !=
                                      confirmPasswordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Passwords do not match'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  context
                                      .read<AuthCubit>()
                                      .confirmPasswordReset(
                                        email: widget.email,
                                        otp: widget.otp,
                                        newPassword: passwordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                      );
                                },
                        );
                      },
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