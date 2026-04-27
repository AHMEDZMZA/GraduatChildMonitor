import 'package:flutter/material.dart';
import '../widgets/profile_top_header.dart';
import '../widgets/setting_switch_tile.dart';

class NotificationSettingView extends StatefulWidget {
  const NotificationSettingView({super.key});

  @override
  State<NotificationSettingView> createState() =>
      _NotificationSettingViewState();
}

class _NotificationSettingViewState extends State<NotificationSettingView> {
  bool generalNotification = true;
  bool sound = true;
  bool vibrate = false;

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
              const ProfileTopHeader(title: 'Notification Setting'),
              const SizedBox(height: 34),

              SettingSwitchTile(
                title: 'General Notification',
                value: generalNotification,
                onChanged: (value) {
                  setState(() {
                    generalNotification = value;
                  });
                },
              ),

              SettingSwitchTile(
                title: 'Sound',
                value: sound,
                onChanged: (value) {
                  setState(() {
                    sound = value;
                  });
                },
              ),

              SettingSwitchTile(
                title: 'vibrate',
                value: vibrate,
                onChanged: (value) {
                  setState(() {
                    vibrate = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}