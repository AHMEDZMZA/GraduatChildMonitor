import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../domain/entities/test_submission_entity.dart';

class TestCompleteView extends StatelessWidget {
  final TestResultEntity result;

  const TestCompleteView({super.key, required this.result});

  Color _getRiskColor() {
    if (result.riskScore >= 70) {
      return Colors.red;
    } else if (result.riskScore >= 40) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _getRiskLevel() {
    if (result.riskScore >= 70) {
      return 'High Risk';
    } else if (result.riskScore >= 40) {
      return 'Moderate Risk';
    } else {
      return 'Low Risk';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
              const SizedBox(height: 50),
              Center(
                child: Image.asset(AppAssets.resultTest, width: 85, height: 85),
              ),
              const SizedBox(height: 24),
              const Text(
                AppStrings.testCompleteTitle,
                style: AppTextStyles.nunito30w900Black,
              ),
              const SizedBox(height: 12),
              Text(
                'Test completed for ${result.childName}',
                style: AppTextStyles.nunito14w400Grey,
              ),
              const SizedBox(height: 50),
              Center(
                child: Container(
                  width: 306,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorManager.babyBlue,
                    border: Border.all(
                      color: ColorManager.primaryBlue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        result.testType.toUpperCase(),
                        style: AppTextStyles.nunito15w900primaryBlue,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Result: ${result.result}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getRiskColor().withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getRiskColor(), width: 1),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getRiskLevel(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getRiskColor(),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Risk Score: ${result.riskScore.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 13,
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
