import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? childId;
  final VoidCallback? onStatisticsTap;

  const HomeHeader({
    super.key,
    required this.userName,
    this.childId,
    this.onStatisticsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Hello, $userName!',
              style: AppTextStyles.nunito30w900Black,
            ),
          ),
          if (childId != null)
            IconButton(
              onPressed: onStatisticsTap,
              icon: const Icon(
                Icons.bar_chart,
                color: ColorManager.primaryBlue,
              ),
            ),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(AppAssets.profileIcon),
          ),
        ],
      ),
    );
  }
}
