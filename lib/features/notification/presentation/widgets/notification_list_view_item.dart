import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/color_manager.dart';
import '../../domain/entities/notification_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationListViewItem extends StatelessWidget {
  final NotificationEntity item;
  final VoidCallback? onTap;

  const NotificationListViewItem({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isHighlighted = item.highlighted;
    final type = item.type;

    // 1. Dynamic setup based on Notification Type
    Color cardBgColor = isHighlighted ? ColorManager.veryLightBlue : ColorManager.babyBlue;
    Color borderColor = isHighlighted ? ColorManager.primaryBlue : Colors.transparent;
    Color iconBgColor = ColorManager.primaryBlue.withValues(alpha: 0.1);
    Color iconColor = ColorManager.primaryBlue;
    IconData leadingIcon = Icons.notifications_none_rounded;

    if (type == 'daily_quote') {
      // Golden/Yellow theme for daily motivational quotes
      cardBgColor = ColorManager.brightYellow.withValues(alpha: 0.12);
      borderColor = ColorManager.goldFFBB.withValues(alpha: 0.5);
      iconBgColor = ColorManager.goldFFBB.withValues(alpha: 0.2);
      iconColor = ColorManager.darkGold;
      leadingIcon = Icons.format_quote_rounded;
    } else if (type == 'activity_completed') {
      // Emerald Teal theme for completed tasks/activities
      cardBgColor = const Color(0xFFE6F9F2); // very light green
      borderColor = const Color(0xFFB3ECD5);
      iconBgColor = ColorManager.brightTeal.withValues(alpha: 0.15);
      iconColor = ColorManager.brightTeal;
      leadingIcon = Icons.task_alt_rounded;
    } else if (type == 'assessment_completed') {
      // Purple theme for monthly developmental testing milestones
      cardBgColor = const Color(0xFFFAF2FF); // very light purple
      borderColor = const Color(0xFFE7D0FF);
      iconBgColor = Colors.purple.withValues(alpha: 0.12);
      iconColor = Colors.purple;
      leadingIcon = Icons.analytics_rounded;
    } else if (type == 'security_alert') {
      // Soft red theme for profile/password settings alerts
      cardBgColor = const Color(0xFFFFECEF); // very light red
      borderColor = const Color(0xFFFFBCC4);
      iconBgColor = ColorManager.errorRed.withValues(alpha: 0.1);
      iconColor = ColorManager.errorRed;
      leadingIcon = Icons.security_rounded;
    } else if (type == 'reminder') {
      // Sky blue theme for plan/milestones reminders
      cardBgColor = ColorManager.babyBlue.withValues(alpha: 0.6);
      borderColor = ColorManager.skyBlue.withValues(alpha: 0.4);
      iconBgColor = ColorManager.skyBlue.withValues(alpha: 0.2);
      iconColor = ColorManager.primaryBlue;
      leadingIcon = Icons.alarm_rounded;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: borderColor,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Colored status circle on the left with icon
            CircleAvatar(
              backgroundColor: iconBgColor,
              radius: 22.r,
              child: Icon(
                leadingIcon,
                color: iconColor,
                size: 22.r,
              ),
            ),
            SizedBox(width: 14.w),

            // Text contents
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.nearBlack,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    item.date,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorManager.grayB0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // Arrow forward indicator
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: ColorManager.grayB0,
            ),
          ],
        ),
      ),
    );
  }
}
