import 'package:flutter/material.dart';
import '../../../../core/managers/color_manager.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationListViewItem extends StatelessWidget {
  final NotificationEntity item;
  final VoidCallback? onTap;

  const NotificationListViewItem({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isHighlighted = item.highlighted;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
        decoration: BoxDecoration(
          color:
              isHighlighted
                  ? ColorManager.veryLightBlue
                  : ColorManager.babyBlue,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isHighlighted ? ColorManager.primaryBlue : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black8,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.nearBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.date,
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorManager.grayB0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: ColorManager.darkGray,
            ),
          ],
        ),
      ),
    );
  }
}
