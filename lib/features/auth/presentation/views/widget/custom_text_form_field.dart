import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.isPassword,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.obscuringCharacter,
    this.readOnly,
    this.onTap,
    this.extraValidator,
  });

  final String hintText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? obscuringCharacter;
  final bool? readOnly;
  final Function()? onTap;
  /// Optional extra validation logic appended after built-in checks.
  final String? Function(String?)? extraValidator;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter ${widget.hintText}';
    }

    if (widget.keyboardType == TextInputType.emailAddress) {
      final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email';
      }
    }

    if (widget.isPassword) {
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
    }

    // Allow caller to inject extra validation (e.g. password-match check).
    return widget.extraValidator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly ?? false,
      onTap: widget.onTap,
      controller: widget.controller,
      obscureText: _obscureText,
      obscuringCharacter: widget.obscuringCharacter ?? '*',
      cursorHeight: 20,
      cursorColor: Theme.of(context).colorScheme.primary,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _validator,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 14.h,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.isPassword
                ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
                : widget.suffixIcon,
        hintText: widget.hintText,
        // All other decoration comes from theme
      ),
    );
  }
}
