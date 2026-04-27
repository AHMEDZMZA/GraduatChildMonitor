import 'package:child_monitor_app/features/noification/presentation/view/single_notification_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../data/model/notification_item_model.dart';
import '../widgets/notification_list_view_item.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.center,
              children: [
                const CustomText(
                  text: 'Notification',
                  style: AppTextStyles.nunito32w900Black,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          builder: (_) {
                            return AppBottomSheet(
                              title: 'Clear All Notifications',
                              description:
                                  'Are you sure you want to clear all Notifications?',
                              confirmText: 'Clear',
                              onConfirm: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        size: 24,
                        color: ColorManager.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return NotificationListViewItem(
                      item: notifications[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const SingleNotificationScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
