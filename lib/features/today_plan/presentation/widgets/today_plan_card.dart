import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/today_plan_model.dart';

class TodayPlanCard extends StatelessWidget {
  final TodayPlanModel item;
  final VoidCallback? onTap;

  const TodayPlanCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorManager.backgroundWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColorManager.primaryBlue, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black8,
              blurRadius: 10,
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
                width: 86,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.nunito16w900Green.copyWith(
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.description,
                    style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 8),

                  ...item.points.map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.circle,
                              size: 4,
                              color: ColorManager.darkText,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              point,
                              style: AppTextStyles.nunito12w600overlayGray66
                                  .copyWith(
                                    fontSize: 11,
                                    color: ColorManager.darkText,
                                    height: 1.35,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: CustomPaint(
                      size: const Size(double.infinity, 1),
                      painter: _DashedLinePainter(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.primaryBlue,
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 11,
                  color: ColorManager.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;

    final paint =
        Paint()
          ..color = ColorManager.grayCB
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
