import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../cubit/profile_cubit.dart';
import '../state/profile_state.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_option_item.dart';
import '../widgets/profile_top_header.dart';
import '../widgets/theme_toggle_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              const ProfileTopHeader(title: 'Settings'),
              SizedBox(height: 24.h),

              Center(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    String name = 'User Name';
                    String? imageUrl;
                    int? loadedTimestamp;
                    if (state is UserProfileLoaded) {
                      name = state.profile.monitorName;
                      imageUrl = state.profile.profileImage;
                      loadedTimestamp = state.profile.loadedTimestamp;
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.editProfile);
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              width: 2,
                            ),
                          ),
                          child: ProfileAvatarSection(
                            imagePath: AppAssets.profileProfile,
                            userName: name,
                            profileImageUrl: imageUrl,
                            showEditIcon: false,
                            loadedTimestamp: loadedTimestamp,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 24.h),

              const ThemeToggleItem(),

              SizedBox(height: 8.h),

              ProfileOptionItem(
                icon: Icons.lightbulb_outline,
                title: 'Notification Setting',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.notificationSettings);
                },
              ),

              SizedBox(height: 8.h),

              ProfileOptionItem(
                icon: Icons.key_outlined,
                title: 'Password Manager',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.passwordManager);
                },
              ),

              SizedBox(height: 8.h),

              ProfileOptionItem(
                icon: Icons.person_outline,
                title: 'Delete Account',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    builder: (_) {
                      return AppBottomSheet(
                        title: 'Delete Account',
                        description:
                            'Are you sure you want to delete your account?',
                        confirmText: 'Yes,Delete',
                        onConfirm: () {
                          Navigator.pop(context);
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
    );
  }
}
