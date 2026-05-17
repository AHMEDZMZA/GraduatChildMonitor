import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/managers/color_manager.dart';

class CustomPinCodeFields extends StatelessWidget {
  final TextEditingController controller;

  const CustomPinCodeFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: controller,
      autoFocus: true,
      cursorColor:
          Theme.of(context).textTheme.bodyLarge?.color ?? ColorManager.darkText,
      keyboardType: TextInputType.number,
      length: 6,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 44,
        fieldWidth: 48,
        activeColor: ColorManager.deepAqua,
        inactiveColor: ColorManager.softGray,
        inactiveFillColor: Theme.of(context).cardColor,
        activeFillColor: Theme.of(context).cardColor,
        selectedColor: ColorManager.primaryBlue,
        selectedFillColor: Theme.of(context).cardColor,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      hintCharacter: '-',
      hintStyle: const TextStyle(
        color: ColorManager.mediumGray,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (value) {},
      onCompleted: (value) {},
    );
  }
}
