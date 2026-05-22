import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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

              const SizedBox(height: 30),

              const CustomText(
                text: 'Monthly Assessment Result',
                style: AppTextStyles.nunito30w900Black,
                textAlign: TextAlign.center,
              ),

              const CustomText(
                text: 'Here is your child\'s monthly assessment.',
                style: AppTextStyles.nunito14w400Grey,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 150),

              Center(
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(38),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
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
                          borderRadius: BorderRadius.circular(10),
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
                              style: const TextStyle(
                                fontSize: 10,
                                color: ColorManager.grayB0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      CustomText(
                        text: item.resultLabel,
                        style: AppTextStyles.nunito16w900Green,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

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
