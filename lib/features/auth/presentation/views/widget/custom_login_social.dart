import 'package:flutter/material.dart';

import '../../../../../core/managers/color_manager.dart';

class CustomLoginSocial extends StatelessWidget {
  const CustomLoginSocial({
    super.key,
    required this.name,
    required this.text,
    required this.onTap,
  });

  final String name;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 372,
        height: 51.23,
        decoration: ShapeDecoration(
          color: ColorManager.lightGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.88),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(name, width: 24, height: 24),
            const SizedBox(width: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ColorManager.darkText,
                fontSize: 16,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
