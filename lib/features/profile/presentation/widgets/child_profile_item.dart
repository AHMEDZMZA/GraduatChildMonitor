import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';

class ChildProfileItem extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;

  const ChildProfileItem({super.key, required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            const Icon(
              Icons.person_outline,
              color: ColorManager.primaryBlue,
              size: 24,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: CustomText(
                text: name,
                style: AppTextStyles.nunito20w900Black.copyWith(
                  fontSize: 16,
                  color: ColorManager.darkText,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: ColorManager.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
