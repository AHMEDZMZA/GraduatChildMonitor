import 'package:child_monitor_app/features/profile/presentation/view/settings_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_option_item.dart';
import 'children_profiles_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Center(
                child: CustomText(
                  text: 'My Profile',
                  style: AppTextStyles.nunito30w900Black.copyWith(
                    color: ColorManager.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              const Center(
                child: ProfileAvatarSection(
                  imagePath: AppAssets.profileProfile,
                  userName: 'User Name',
                ),
              ),

              const SizedBox(height: 34),

              ProfileOptionItem(
                icon: Icons.person_outline,
                title: 'Children Profiles',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChildrenProfilesView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              ProfileOptionItem(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              ProfileOptionItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              ProfileOptionItem(
                icon: Icons.logout_outlined,
                title: 'Logout',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    builder: (_) {
                      return AppBottomSheet(
                        title: 'Logout',
                        description: 'Are you sure you want to logout ',
                        confirmText: 'Yes,Logout',
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
