import 'package:child_monitor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:child_monitor_app/features/auth/presentation/state/auth_state.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_pin_code_fields.dart';
import 'widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          Navigator.pushNamed(
            context,
            AppRoutes.resetPasswordConfirm,
            arguments: {
              'email': widget.email,
              'otp': otpController.text.trim(),
            },
          );
        } else if (state is AuthError) {
          setState(() => errorMessage = state.message);
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
                  EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Verify Your Account',
                    style: AppTextStyles.nunito32w900Black,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text:
                        'We\'ve sent a code to your email, please enter the code below.',
                    style: AppTextStyles.nunito14w400Grey,
                  ),
                  SizedBox(height: 40.h),
                  Text('Enter Code',
                      style: AppTextStyles.nunito16w700Black),
                  SizedBox(height: 15.h),
                  CustomPinCodeFields(controller: otpController),
                  if (errorMessage != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      errorMessage!,
                      style:
                          TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                  SizedBox(height: 40.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text:
                            state is AuthLoading ? 'Verifying...' : 'Submit',
                        onTap: state is AuthLoading
                            ? () {}
                            : () {
                                if (otpController.text.isEmpty ||
                                    otpController.text.length < 6) {
                                  setState(() {
                                    errorMessage =
                                        'Please enter the 6-digit code sent to your email.';
                                  });
                                } else {
                                  setState(() => errorMessage = null);
                                  context.read<AuthCubit>().verifyOtp(
                                        widget.email,
                                        otpController.text.trim(),
                                      );
                                }
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
    );
  }
}