import 'package:flutter/material.dart';
import '../../../../core/managers/color_manager.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const HomeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          //  color: isSelected ? ColorManager.veryLightBlue : ColorManager.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? ColorManager.primaryBlue : Colors.black,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black8,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    image,
                    width: 91,
                    height: 91,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: ColorManager.primaryBlue,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: ColorManager.grayB0,
                          height: 1.35,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 91,
                  child: Center(
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
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _DashedLinePainter(),
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

    final paint = Paint()
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
