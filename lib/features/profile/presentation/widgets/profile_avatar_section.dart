import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String imagePath;
  final String userName;

  const ProfileAvatarSection({
    super.key,
    required this.imagePath,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(radius: 44, backgroundImage: AssetImage(imagePath)),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorManager.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 14,
                  color: ColorManager.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomText(text: userName, style: AppTextStyles.nunito20w900Black),
      ],
    );
  }
}
