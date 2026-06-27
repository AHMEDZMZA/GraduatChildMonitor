import 'package:child_monitor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:child_monitor_app/features/auth/presentation/state/auth_state.dart';
import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_option_item.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _userName = 'User Name';
  String? _profileImageUrl;
  int? _loadedTimestamp;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    // Force rebuild on locale change
    final _ = context.locale;

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is UserProfileLoaded) {
              setState(() {
                _userName = state.profile.monitorName;
                _profileImageUrl = state.profile.profileImage;
                _loadedTimestamp = state.profile.loadedTimestamp;
              });
            } else if (state is AccountDeleted) {
              // Account deleted - go back to login
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('account_deleted_success'.tr()),
                  backgroundColor: ColorManager.brightTeal,
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('logout_success'.tr()),
                  backgroundColor: ColorManager.brightTeal,
                ),
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
        ),
      ],
      child: Scaffold(
        // backgroundColor: ColorManager.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                Center(
                  child: CustomText(
                    text: 'my_profile'.tr(),
                    style: AppTextStyles.nunito30w900Black.copyWith(
                      color: ColorManager.primaryBlue,
                    ),
                  ),
                ),
                SizedBox(height: 28.h),

                Center(
                  child: ProfileAvatarSection(
                    imagePath: AppAssets.profileProfile,
                    userName: _userName,
                    profileImageUrl: _profileImageUrl,
                    loadedTimestamp: _loadedTimestamp,
                  ),
                ),

                SizedBox(height: 34.h),

                ProfileOptionItem(
                  icon: Icons.person_outline,
                  title: 'children_profiles'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.childrenProfiles);
                  },
                ),

                SizedBox(height: 8.h),

                ProfileOptionItem(
                  icon: Icons.person_outline,
                  title: 'profile'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.editProfile);
                  },
                ),

                SizedBox(height: 8.h),

                ProfileOptionItem(
                  icon: Icons.settings_outlined,
                  title: 'settings'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
                ),

                SizedBox(height: 8.h),

                ProfileOptionItem(
                  icon: Icons.logout_outlined,
                  title: 'logout'.tr(),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      elevation: 0,
                      builder: (_) {
                        return AppBottomSheet(
                          title: 'logout'.tr(),
                          description: 'are_you_sure_logout'.tr(),
                          confirmText: 'yes_logout'.tr(),
                          onConfirm: () {
                            Navigator.pop(context);
                            context.read<AuthCubit>().logout();
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
