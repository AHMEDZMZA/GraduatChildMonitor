import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/di/service_locator.dart';

class LanguageToggleItem extends StatelessWidget {
  const LanguageToggleItem({super.key});

  void _changeLanguage(BuildContext context, String newLocale) {
    context.setLocale(Locale(newLocale));
    getIt<SharedPreferences>().setString('app_lang', newLocale);
  }

  void _showArabicNoticeDialog(BuildContext context, String newLocale) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: ColorManager.gold.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: ColorManager.darkGold,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'arabic_notice_title'.tr(),
                  style: AppTextStyles.nunito18w900Black.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'arabic_notice_body'.tr(),
                  style: AppTextStyles.nunito14w400Grey.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ?? ColorManager.softGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: ColorManager.grayB9.withValues(alpha: 0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(
                          'arabic_notice_cancel'.tr(),
                          style: AppTextStyles.nunito14w900Black.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          _changeLanguage(context, newLocale);
                        },
                        child: Text(
                          'arabic_notice_proceed'.tr(),
                          style: AppTextStyles.nunito14w400White.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.overlayGray66.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ColorManager.buttonBlue,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: const Icon(
              Icons.language_outlined,
              color: ColorManager.primaryBlue,
              size: 20,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              'language'.tr(),
              style: AppTextStyles.nunito16w900Black.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          DropdownButton<String>(
            value: currentLocale,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: ColorManager.primaryBlue),
            items: [
              DropdownMenuItem(
                value: 'en',
                child: Text('english'.tr(), style: AppTextStyles.nunito14w400Grey),
              ),
              DropdownMenuItem(
                value: 'ar',
                child: Text('arabic'.tr(), style: AppTextStyles.nunito14w400Grey),
              ),
            ],
            onChanged: (String? newLocale) {
              if (newLocale != null) {
                if (newLocale == 'ar' && currentLocale != 'ar') {
                  _showArabicNoticeDialog(context, newLocale);
                } else {
                  _changeLanguage(context, newLocale);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
