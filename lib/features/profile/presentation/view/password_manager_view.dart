import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text_form_field.dart';
import '../widgets/profile_top_header.dart';

class PasswordManagerView extends StatefulWidget {
  const PasswordManagerView({super.key});

  @override
  State<PasswordManagerView> createState() => _PasswordManagerViewState();
}

class _PasswordManagerViewState extends State<PasswordManagerView> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is PasswordChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully!'),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          // Clear controllers after success
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        } else if (state is ProfileError) {
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileTopHeader(title: 'Password Manager'),
                    const SizedBox(height: 34),

                    const Text(
                      'Current Password',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    const SizedBox(height: 10),

                    CustomTextFormField(
                      isPassword: true,
                      hintText: 'Enter current password',
                      controller: currentPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.nunito14w400Grey.copyWith(
                          color: ColorManager.primaryBlue,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'New Password',
                      style: AppTextStyles.nunito16w900Black,
                    ),

                    const SizedBox(height: 10),

                    CustomTextFormField(
                      isPassword: true,
                      hintText: 'Enter new password',
                      controller: newPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Confirm New Password',
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    const SizedBox(height: 10),

                    CustomTextFormField(
                      isPassword: true,
                      hintText: 'Confirm new password',
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    const SizedBox(height: 60),

                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: state is ProfileLoading
                              ? 'Changing...'
                              : 'Change Password',
                          onTap: state is ProfileLoading
                              ? () {}
                              : () {
                                  if (!_formKey.currentState!.validate())
                                    return;
                                  if (newPasswordController.text !=
                                      confirmPasswordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Passwords do not match'),
                                        backgroundColor: ColorManager.errorRed,
                                      ),
                                    );
                                    return;
                                  }
                                  context.read<ProfileCubit>().changePassword(
                                    currentPassword:
                                        currentPasswordController.text,
                                    newPassword: newPasswordController.text,
                                    confirmNewPassword:
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
