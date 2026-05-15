import 'package:child_monitor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:child_monitor_app/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import 'widget/custom_button.dart';
import 'widget/custom_text.dart';
import 'widget/custom_text_form_field.dart';
import '../../../../core/navigation/app_routes.dart';

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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetRequestSent) {
          Navigator.pushNamed(
            context,
            AppRoutes.resetPasswordVerify,
            arguments: emailController.text.trim(),
          );
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
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
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
                      text:
                          'Enter the email address registered with your account. We will send you a code to reset your password.',
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
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: state is AuthLoading ? 'Sending...' : 'Submit',
                          onTap: state is AuthLoading
                              ? () {}
                              : () {
                                  if (!formKey.currentState!.validate()) return;
                                  context.read<AuthCubit>().requestPasswordReset(
                                        emailController.text.trim(),
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