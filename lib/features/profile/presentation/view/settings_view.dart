import 'package:child_monitor_app/core/managers/color_manager.dart';

import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../cubit/profile_cubit.dart';
import '../state/profile_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../widgets/profile_option_item.dart';
import '../widgets/profile_top_header.dart';
import '../widgets/theme_toggle_item.dart';
import '../widgets/language_toggle_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    // Force rebuild on locale change
    final _ = context.locale;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is AccountDeleted) {
                // When account is successfully deleted on the backend, clear local session
                context.read<AuthCubit>().logout();
              } else if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: ColorManager.errorRed,
                  ),
                );
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
          ),
        ],
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                ProfileTopHeader(title: 'settings'.tr()),
                SizedBox(height: 24.h),

                const LanguageToggleItem(),

                SizedBox(height: 8.h),

                const ThemeToggleItem(),

                SizedBox(height: 8.h),

                ProfileOptionItem(
                  icon: Icons.lightbulb_outline,
                  title: 'notification_setting'.tr(),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.notificationSettings,
                    );
                  },
                ),

                SizedBox(height: 8.h),

                ProfileOptionItem(
                  icon: Icons.key_outlined,
                  title: 'password_manager'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.passwordManager);
                  },
                ),

                SizedBox(height: 8.h),

                ProfileOptionItem(
                  icon: Icons.person_outline,
                  title: 'delete_account'.tr(),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      builder: (_) {
                        return AppBottomSheet(
                          title: 'delete_account'.tr(),
                          description:
                              'Are you sure you want to delete your account?',
                          confirmText: 'Yes, Delete',
                          onConfirm: () {
                            Navigator.pop(context);
                            context.read<ProfileCubit>().deleteAccount();
                          },
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
    );
  }
}
