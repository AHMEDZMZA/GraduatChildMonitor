import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/managers/theme_cubit.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeToggleItem extends StatelessWidget {
  const ThemeToggleItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: ColorManager.primaryBlue,
                size: 24,
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: CustomText(
                  text: 'Dark Mode',
                  style: AppTextStyles.nunito20w900Black.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ),
              Switch(
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                activeThumbColor: ColorManager.primaryBlue,
              ),
            ],
          ),
        );
      },
    );
  }
}
