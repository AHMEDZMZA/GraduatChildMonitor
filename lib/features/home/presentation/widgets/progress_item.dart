import 'package:flutter/material.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/network/api_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressItem extends StatelessWidget {
  final MonthlyAssessmentHistoryItem item;
  final bool highlighted;
  final VoidCallback onTap;

  const ProgressItem({
    super.key,
    required this.item,
    required this.highlighted,
    required this.onTap,
  });

  String _getShortMonth(String monthYear) {
    if (monthYear.isEmpty) return 'MAY';
    final parts = monthYear.split(' ');
    if (parts.isNotEmpty) {
      final m = parts[0];
      if (m.length >= 3) {
        return m.substring(0, 3).toUpperCase();
      }
      return m.toUpperCase();
    }
    return 'MAY';
  }

  String _formatDate(String dateStr) {
    try {
      // Parse and convert to local time so the displayed date matches
      // the user's timezone (server returns UTC).
      final dateTimeUtc = DateTime.parse(dateStr);
      final dateTime = dateTimeUtc.isUtc ? dateTimeUtc.toLocal() : dateTimeUtc.toLocal();
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = months[dateTime.month - 1];
      final year = dateTime.year;
      final hour24 = dateTime.hour;
      final period = hour24 >= 12 ? 'PM' : 'AM';
      final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$day $month $year | ${hour12.toString().padLeft(2, '0')}:$minute $period';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: highlighted ? ColorManager.primaryBlue : Colors.transparent,
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black8,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 60,
              decoration: BoxDecoration(
                color: highlighted
                    ? ColorManager.primaryBlue
                    : Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${item.id}',
                    style: TextStyle(
                      color: highlighted
                          ? ColorManager.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    _getShortMonth(item.monthYear),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: highlighted ? ColorManager.white : ColorManager.grayB0,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.resultLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _formatDate(item.assessmentDate),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorManager.grayB0,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}