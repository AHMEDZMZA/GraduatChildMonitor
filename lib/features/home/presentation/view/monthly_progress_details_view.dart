import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../data/model.dart';

class MonthlyProgressDetailsView extends StatelessWidget {
  final MonthlyProgressModel item;

  const MonthlyProgressDetailsView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
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
                    color: ColorManager.veryLightBlue,
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
                        width: 28,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorManager.backgroundWhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${item.id}',
                              style: TextStyle(
                                color: item.highlighted
                                    ? ColorManager.white
                                    : ColorManager.darkText,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              item.month,
                              style: TextStyle(
                                fontSize: 10,
                                color: item.highlighted
                                    ? ColorManager.white
                                    : ColorManager.grayB0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      const CustomText(
                        text:
                        'Noticeable improvement in your child’s condition',
                        style: AppTextStyles.nunito16w900Green,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      const CustomText(
                        text:
                        'Continue with the current plan as it shows positive results.\nRegular follow-up leads to better outcomes.',
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