import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyProgressDetailsView extends StatelessWidget {
  final MonthlyAssessmentHistoryItem item;

  const MonthlyProgressDetailsView({super.key, required this.item});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    backgroundColor: ColorManager.buttonBlue,
                    radius: 18,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              CustomText(
                text: 'monthly_assessment_result'.tr(),
                style: AppTextStyles.nunito30w900Black,
                textAlign: TextAlign.center,
              ),

              CustomText(
                text: 'here_is_assessment'.tr(),
                style: AppTextStyles.nunito14w400Grey,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 150.h),

              Center(
                child: Container(
                  width: 260,
                  padding: EdgeInsets.all(38.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: ColorManager.primaryBlue),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.black8,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${item.id}',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              _getShortMonth(item.monthYear),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorManager.grayB0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 14.h),

                      CustomText(
                        text: item.resultLabel,
                        style: AppTextStyles.nunito16w900Green,
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 10.h),

                      CustomText(
                        text: item.recommendations,
                        style: AppTextStyles.nunito12w600overlayGray66,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

