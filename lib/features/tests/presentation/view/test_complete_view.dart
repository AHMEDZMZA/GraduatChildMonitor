import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../domain/entities/test_submission_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestCompleteView extends StatelessWidget {
  final TestResultEntity result;

  const TestCompleteView({super.key, required this.result});

  Color _getRiskColor() {
    final score = result.riskScore ?? 0.0;
    if (score >= 70) {
      return Colors.red;
    } else if (score >= 40) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _getRiskLevel() {
    final score = result.riskScore ?? 0.0;
    if (score >= 70) {
      return 'High Risk';
    } else if (score >= 40) {
      return 'Moderate Risk';
    } else {
      return 'Low Risk';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: ColorManager.buttonBlue,
                  radius: 20,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Center(
                child: Image.asset(AppAssets.resultTest, width: 85, height: 85),
              ),
              SizedBox(height: 24.h),
              Text(
                AppStrings.testCompleteTitle,
                style: AppTextStyles.nunito30w900Black,
              ),
              SizedBox(height: 12.h),
              Text(
                'Test completed for ${result.childName}',
                style: AppTextStyles.nunito14w400Grey,
              ),
              SizedBox(height: 50.h),
              Center(
                child: Container(
                  width: 306,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: ColorManager.babyBlue,
                    border: Border.all(
                      color: ColorManager.primaryBlue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        result.testType.toUpperCase(),
                        style: AppTextStyles.nunito15w900primaryBlue,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Result: ${result.result}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getRiskColor().withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: _getRiskColor(), width: 1),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getRiskLevel(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: _getRiskColor(),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Risk Score: ${(result.riskScore ?? 0.0).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: _getRiskColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                text: AppStrings.startPlan,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.mainNav,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
