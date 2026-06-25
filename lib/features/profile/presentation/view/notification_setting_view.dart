import 'package:flutter/material.dart';
import '../widgets/profile_top_header.dart';
import '../widgets/setting_switch_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              const ProfileTopHeader(title: 'Notification Setting'),
              SizedBox(height: 34.h),

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