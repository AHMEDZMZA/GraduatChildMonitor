import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/di/service_locator.dart';

class LanguageToggleItem extends StatelessWidget {
  const LanguageToggleItem({super.key});

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
                // Update easy_localization
                context.setLocale(Locale(newLocale));
                
                // Update SharedPreferences for the Interceptor
                getIt<SharedPreferences>().setString('app_lang', newLocale);
              }
            },
          ),
        ],
      ),
    );
  }
}
