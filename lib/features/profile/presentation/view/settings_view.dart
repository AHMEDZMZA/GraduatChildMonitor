import 'package:child_monitor_app/features/profile/presentation/view/password_manager_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../widgets/profile_option_item.dart';
import '../widgets/profile_top_header.dart';
import 'notification_setting_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const ProfileTopHeader(title: 'Settings'),
              const SizedBox(height: 34),

              ProfileOptionItem(
                icon: Icons.lightbulb_outline,
                title: 'Notification Setting',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationSettingView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              ProfileOptionItem(
                icon: Icons.key_outlined,
                title: 'Password Manager',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PasswordManagerView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              ProfileOptionItem(
                icon: Icons.person_outline,
                title: 'Delete Account',
                onTap: () {      showModalBottomSheet(
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
                );},
              ),
            ],
          ),
        ),
      ),
    );
  }
}