import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';

class ProfileOptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileOptionItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: ColorManager.primaryBlue, size: 24),
            const SizedBox(width: 18),
            Expanded(
              child: CustomText(
                text: title,
                style: AppTextStyles.nunito20w900Black.copyWith(
                  fontSize: 16,
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
