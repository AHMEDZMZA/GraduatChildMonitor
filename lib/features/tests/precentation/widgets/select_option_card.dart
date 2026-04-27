import 'package:flutter/material.dart';
import '../../../../../core/managers/app_text_styles.dart';
import '../../../../../core/managers/color_manager.dart';

class SelectOptionCard extends StatelessWidget {
  final int index;
  final int? selectedOption;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SelectOptionCard({
    super.key,
    required this.index,
    required this.selectedOption,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedOption == index;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 306,
        height: 155,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.babyBlue : Colors.white,
          border: Border.all(
            color: ColorManager.primaryBlue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.nunito15w900primaryBlue,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: AppTextStyles.nunito12w600overlayGray66,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
