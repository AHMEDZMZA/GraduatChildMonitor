import 'package:flutter/material.dart';
import '../../../../core/managers/color_manager.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: ColorManager.backgroundWhite,
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: ColorManager.lightGray50,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black8,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              cursorColor: ColorManager.primaryBlue,
              style: const TextStyle(
                fontSize: 14,
                color: ColorManager.darkText,
              ),
              decoration: const InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: TextStyle(
                  color: ColorManager.grayB0,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        GestureDetector(
          onTap: onSend,
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: ColorManager.primaryBlue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primaryBlue30,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.send_rounded,
              color: ColorManager.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}