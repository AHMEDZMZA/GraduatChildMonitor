import 'package:flutter/material.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/model.dart';

class ProgressItem extends StatelessWidget {
  final MonthlyProgressModel item;
  final bool highlighted;
  final VoidCallback onTap;

  const ProgressItem({
    super.key,
    required this.item,
    required this.highlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: highlighted
                ? ColorManager.primaryBlue
                : Colors.transparent,
            width: 1.3,
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
          children: [
            Container(
              width: 42,
              height: 60,
              decoration: BoxDecoration(
                color: highlighted
                    ? ColorManager.primaryBlue
                    : Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${item.id}',
                    style: TextStyle(
                      color: highlighted
                          ? ColorManager.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    item.month,
                    style: TextStyle(
                      fontSize: 10,
                      color: highlighted
                          ? ColorManager.white
                          : ColorManager.grayB0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.date,
                    style: const TextStyle(
                      fontSize: 11,
                      color: ColorManager.grayB0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}