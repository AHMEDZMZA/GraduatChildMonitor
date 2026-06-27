import 'package:easy_localization/easy_localization.dart';
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
              ProfileTopHeader(title: 'notification_setting'.tr()),
              SizedBox(height: 34.h),

              SettingSwitchTile(
                title: 'general_notification'.tr(),
                value: generalNotification,
                onChanged: (value) {
                  setState(() {
                    generalNotification = value;
                  });
                },
              ),

              SettingSwitchTile(
                title: 'sound'.tr(),
                value: sound,
                onChanged: (value) {
                  setState(() {
                    sound = value;
                  });
                },
              ),

              SettingSwitchTile(
                title: 'vibrate'.tr(),
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
