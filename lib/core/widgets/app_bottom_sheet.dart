import 'package:flutter/material.dart';
import '../managers/color_manager.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final VoidCallback onConfirm;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: const BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ColorManager.nearBlack,
            ),
          ),

          const SizedBox(height: 14),
          const Divider(color: ColorManager.grayB0, thickness: 1),

          /// Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: ColorManager.grayB0),
          ),

          const SizedBox(height: 22),

          /// Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryBlue10,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: ColorManager.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Confirm
              Expanded(
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: onConfirm,
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        color: ColorManager.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
