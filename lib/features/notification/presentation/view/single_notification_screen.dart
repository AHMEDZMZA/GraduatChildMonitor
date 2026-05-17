import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';

import '../../data/model/notification_item_model.dart';

class SingleNotificationScreen extends StatelessWidget {
  final NotificationItemModel? item;
  const SingleNotificationScreen({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorManager.white,
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
                    padding: const EdgeInsets.only(right: 18),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          builder: (_) {
                            return AppBottomSheet(
                              title: 'Delete This Notification',
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
                        //    color: ColorManager.black,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
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

            const SizedBox(height: 38),

            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.86,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: ColorManager.primaryBlue,
                      width: 1.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: item?.title ?? 'Great progress today!',
                        style: AppTextStyles.nunito20w900Black,
                      ),

                      SizedBox(height: 22),

                      Text(
                        'Well done! Keep going!"\n'
                        '"A new achievement to celebrate.\n\n'
                        '"It\'s time for today\'s activity"\n'
                        '"Don\'t forget to review today\'s task!"\n\n'
                        '"Everything looks good 💙"\n'
                        '"Today\'s assessment is ready"\n'
                        '"Your child had a great day!"',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.notificationDetailsText,
                      ),
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
