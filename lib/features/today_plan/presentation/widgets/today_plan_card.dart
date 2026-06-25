import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/today_plan_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        margin: EdgeInsets.only(bottom: 18.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18.r),
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
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                item.image,
                width: 86,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.nunito16w900Green.copyWith(
                      fontSize: 15.sp,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    item.description,
                    style: AppTextStyles.nunito12w600overlayGray66.copyWith(
                      fontSize: 11.sp,
                      height: 1.45,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  ...item.points.map(
                    (point) => Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Icon(
                              Icons.circle,
                              size: 4,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              point,
                              style: AppTextStyles.nunito12w600overlayGray66
                                  .copyWith(
                                    fontSize: 11.sp,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    height: 1.35,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: CustomPaint(
                      size: const Size(double.infinity, 1),
                      painter: _DashedLinePainter(),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            Padding(
              padding: EdgeInsets.only(top: 50.h),
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
