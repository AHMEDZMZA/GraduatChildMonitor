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
    final isDailyQuote = item.type == 'daily_quote';

    // Special layout for daily quote
    if (isDailyQuote && item.quote != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E68C), // Light yellow background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFFD700), // Gold border
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.stars, color: Color(0xFFFFD700), size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Daily Quote',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorManager.nearBlack,
                      ),
                    ),
                  ),
                  const Icon(Icons.format_quote, color: Color(0xFFFFD700), size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '"${item.quote}"',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorManager.nearBlack,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.date,
                style: const TextStyle(
                  fontSize: 12,
                  color: ColorManager.grayB0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Default layout for other notifications
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
