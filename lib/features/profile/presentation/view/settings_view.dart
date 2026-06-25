import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../widgets/profile_option_item.dart';
import '../widgets/profile_top_header.dart';
import '../widgets/theme_toggle_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

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
              SizedBox(height: 34.h),

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
