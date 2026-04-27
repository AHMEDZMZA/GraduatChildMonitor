import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Hello, Mam!',
              style: AppTextStyles.nunito30w900Black,
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(AppAssets.profileIcon),
          ),
        ],
      ),
    );
  }
}