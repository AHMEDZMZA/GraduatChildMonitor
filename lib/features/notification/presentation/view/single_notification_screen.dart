import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../domain/entities/notification_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleNotificationScreen extends StatelessWidget {
  final NotificationEntity? item;
  const SingleNotificationScreen({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final notification = item;
    final isDailyQuote = notification?.type == 'daily_quote';
    final isAlert = notification?.type == 'security_alert';
    
    Color themeColor = ColorManager.primaryBlue;
    IconData typeIcon = Icons.notifications;
    Color iconColor = ColorManager.primaryBlue;
    Color cardBgColor = Theme.of(context).cardColor;

    if (isDailyQuote) {
      themeColor = ColorManager.goldFFBB;
      typeIcon = Icons.format_quote;
      iconColor = ColorManager.darkGold;
      cardBgColor = ColorManager.brightYellow.withValues(alpha: 0.15);
    } else if (isAlert) {
      themeColor = ColorManager.errorRed;
      typeIcon = Icons.security_rounded;
      iconColor = ColorManager.errorRed;
    } else if (notification?.type == 'reminder') {
      themeColor = ColorManager.skyBlue;
      typeIcon = Icons.alarm_rounded;
      iconColor = ColorManager.primaryBlue;
    } else if (notification?.type == 'activity_completed') {
      themeColor = ColorManager.brightTeal;
      typeIcon = Icons.check_circle_outline_rounded;
      iconColor = ColorManager.brightTeal;
    } else if (notification?.type == 'assessment_completed') {
      themeColor = Colors.purple;
      typeIcon = Icons.analytics_outlined;
      iconColor = Colors.purple;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),

            Stack(
              alignment: Alignment.center,
              children: [
                CustomText(
                  text: 'notification'.tr(),
                  style: AppTextStyles.nunito32w900Black,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 18.w),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          builder: (_) {
                            return AppBottomSheet(
                              title: 'delete_this_notification'.tr(),
                              description:
                                  'Are you sure you want to delete this Notification?',
                              confirmText: 'Delete',
                              onConfirm: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        backgroundColor: ColorManager.buttonBlue,
                        radius: 18,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: ColorManager.darkText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 38.h),

            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.86,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 28.h,
                  ),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: themeColor,
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: themeColor.withValues(alpha: 0.1),
                        radius: 32.r,
                        child: Icon(
                          typeIcon,
                          color: iconColor,
                          size: 32.r,
                        ),
                      ),
                      
                      SizedBox(height: 20.h),

                      CustomText(
                        text: notification?.title.tr() ?? 'notification'.tr(),
                        style: AppTextStyles.nunito20w900Black.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        notification?.date ?? '',
                        style: AppTextStyles.nunito14w400Grey,
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 24.h),

                      Divider(
                        color: themeColor.withValues(alpha: 0.3),
                        thickness: 1.2,
                        indent: 20.w,
                        endIndent: 20.w,
                      ),

                      SizedBox(height: 24.h),

                      Text(
                        notification?.body.tr() ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.notificationDetailsText.copyWith(
                          fontSize: 16.sp,
                          height: 1.6,
                          fontStyle: isDailyQuote ? FontStyle.italic : FontStyle.normal,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),

                      if (notification?.type == 'reminder' || notification?.type == 'activity_completed') ...[
                        SizedBox(height: 24.h),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.todayPlan);
                          },
                          icon: const Icon(Icons.calendar_today_rounded, size: 18),
                          label: Text('view_todays_plan'.tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primaryBlue,
                            foregroundColor: ColorManager.white,
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ] else if (notification?.type == 'security_alert') ...[
                        SizedBox(height: 24.h),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.passwordManager);
                          },
                          icon: const Icon(Icons.lock_outline_rounded, size: 18),
                          label: Text('change_password'.tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.errorRed,
                            foregroundColor: ColorManager.white,
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
