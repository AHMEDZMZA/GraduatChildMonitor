import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';

class SettingSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.nunito16w900Black.copyWith(
                fontSize: 15,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: ColorManager.white,
            activeTrackColor: ColorManager.primaryBlue,
            inactiveThumbColor: ColorManager.white,
            inactiveTrackColor: ColorManager.lightGray,
          ),
        ],
      ),
    );
  }
}