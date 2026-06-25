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
    final isDailyQuote = item.type == 'daily_quote';

    // Special layout for daily quote
    if (isDailyQuote && item.quote != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: ColorManager.brightYellow, // Light yellow background
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: ColorManager.goldFFBB, // Gold border
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.overlayBlack20,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.stars,
                    color: ColorManager.goldFFBB,
                    size: 24,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Daily Quote',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorManager.nearBlack,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.format_quote,
                    color: ColorManager.goldFFBB,
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                '"${item.quote}"',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorManager.nearBlack,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 12.h),
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
      );
    }

    // Default layout for other notifications
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 23.h),
        decoration: BoxDecoration(
          color: isHighlighted
              ? ColorManager.veryLightBlue
              : ColorManager.babyBlue,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isHighlighted
                ? ColorManager.primaryBlue
                : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black8,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.nearBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    item.date,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorManager.grayB0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: ColorManager.darkGray,
            ),
          ],
        ),
      ),
    );
  }
}
