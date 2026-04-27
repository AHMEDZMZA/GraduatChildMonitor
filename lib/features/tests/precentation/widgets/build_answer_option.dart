import 'package:flutter/material.dart';

import '../../../../core/managers/color_manager.dart';
class AnswerOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: selected ? ColorManager.primaryBlue : ColorManager.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? ColorManager.primaryBlue : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: ColorManager.primaryBlue25,
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? ColorManager.white : Colors.grey,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Center(
                child: Icon(
                  Icons.circle,
                  size: 10,
                  color: Colors.white,
                ),
              )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
