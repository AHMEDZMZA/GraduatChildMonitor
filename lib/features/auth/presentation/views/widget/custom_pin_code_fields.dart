import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/managers/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPinCodeFields extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onCompleted;

  const CustomPinCodeFields({
    super.key,
    required this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      // No controller passed — library manages its own internal state.
      // Passing an external controller causes double-dispose crashes.
      autoFocus: true,
      cursorColor:
          Theme.of(context).textTheme.bodyLarge?.color ?? ColorManager.darkText,
      keyboardType: TextInputType.number,
      length: 6,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5.r),
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
      hintStyle: TextStyle(
        color: ColorManager.mediumGray,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
      onChanged: onChanged,
      onCompleted: (_) => onCompleted?.call(),
    );
  }
}
