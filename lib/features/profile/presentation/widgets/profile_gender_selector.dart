import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';

class ProfileGenderSelector extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onChanged;

  const ProfileGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile<String>(
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          title: const Text(
            'Male',
            style: AppTextStyles.nunito14w400Black,
          ),
          value: 'Male',
          groupValue: selectedGender,
          activeColor: ColorManager.primaryBlue,
          onChanged: onChanged,
        ),
        RadioListTile<String>(
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          title: const Text(
            'Female',
            style: AppTextStyles.nunito14w400Black,
          ),
          value: 'Female',
          groupValue: selectedGender,
          activeColor: ColorManager.primaryBlue,
          onChanged: onChanged,
        ),
      ],
    );
  }
}