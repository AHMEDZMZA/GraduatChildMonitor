import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';

class ProfileTopHeader extends StatelessWidget {
  final String title;

  const ProfileTopHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomText(
          text: title,
          style: AppTextStyles.nunito32w900Black.copyWith(
            color: ColorManager.primaryBlue,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              backgroundColor: ColorManager.buttonBlue,
              radius: 20,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: ColorManager.darkText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
