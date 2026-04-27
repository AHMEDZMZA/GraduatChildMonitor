import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/activity_model.dart';

class ActivityListItem extends StatelessWidget {
  final ActivityModel item;
  final VoidCallback onTap;

  const ActivityListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorManager.veryLightBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.highlighted
                ? ColorManager.primaryBlue
                : Colors.transparent,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black8,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.image,
                width: 103,
                height: 103,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),

                  Text(
                    item.title,
                    style: AppTextStyles.nunito16w900Black.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.shortDescription,
                    style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                  if (item.completed) ...[
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: ColorManager.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}