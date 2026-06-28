import 'package:child_monitor_app/core/navigation/app_routes.dart';
import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text_form_field.dart';
import '../widgets/profile_top_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:child_monitor_app/core/managers/local_notification_service.dart';
import 'package:easy_localization/easy_localization.dart';

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
          LocalNotificationService().showInstantNotification(
            id: 4,
            title: 'password_changed_title',
            body: 'password_changed_body',
            type: 'security_alert',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('password_changed_success'.tr()),
              backgroundColor: ColorManager.brightTeal,
            ),
          );
          // Clear controllers after success
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          _formKey.currentState?.reset();
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
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileTopHeader(title: 'password_manager'.tr()),
                    SizedBox(height: 34.h),

                    Text(
                      'current_password'.tr(),
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    SizedBox(height: 10.h),

                    CustomTextFormField(
                      isPassword: true,
                      hintText: 'enter_current_password'.tr(),
                      controller: currentPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    SizedBox(height: 8.h),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.resetPasswordRequest,
                          );
                        },
                        child: Text(
                          'forgot_password'.tr(),
                          style: AppTextStyles.nunito14w400Grey.copyWith(
                            color: ColorManager.primaryBlue,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    Text(
                      'new_password'.tr(),
                      style: AppTextStyles.nunito16w900Black,
                    ),

                    SizedBox(height: 10.h),

                    CustomTextFormField(
                      isPassword: true,
                      hintText: 'enter_new_password'.tr(),
                      controller: newPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    SizedBox(height: 18.h),

                    Text(
                      'confirm_new_password'.tr(),
                      style: AppTextStyles.nunito16w900Black,
                    ),
                    SizedBox(height: 10.h),

                    CustomTextFormField(
                      isPassword: true,
                      hintText: 'confirm_new_password'.tr(),
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    SizedBox(height: 60.h),

                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: state is ProfileLoading
                              ? 'changing'.tr()
                              : 'change_password'.tr(),
                          onTap: state is ProfileLoading
                              ? () {}
                              : () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  if (newPasswordController.text !=
                                      confirmPasswordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('passwords_not_match'.tr()),
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
