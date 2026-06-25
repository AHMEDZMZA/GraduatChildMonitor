import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../cubit/notification_cubit.dart';
import '../state/notification_state.dart';
import '../widgets/notification_list_view_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: ColorManager.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Stack(
              alignment: Alignment.center,
              children: [
                CustomText(
                  text: 'Notification',
                  style: AppTextStyles.nunito32w900Black,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.w),
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
                                context.read<NotificationCubit>().clearAll();
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        size: 24,
                        //  color: ColorManager.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationLoaded) {
                    if (state.notifications.isEmpty) {
                      return const Center(child: Text("No notifications yet"));
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: ListView.builder(
                        itemCount: state.notifications.length,
                        itemBuilder: (context, index) {
                          final item = state.notifications[index];
                          return Dismissible(
                            key: Key(item.title + item.date + index.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              decoration: BoxDecoration(
                                color: ColorManager.errorRed,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: ColorManager.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              context
                                  .read<NotificationCubit>()
                                  .deleteNotification(index);
                            },
                            child: NotificationListViewItem(
                              item: item,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.singleNotification,
                                  arguments: item,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is NotificationError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
