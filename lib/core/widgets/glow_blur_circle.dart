import 'dart:ui';
import 'package:flutter/material.dart';

class GlowBlurCircle extends StatelessWidget {
  final bool isBlurred;
  final double width;
  final double height;
  final Gradient gradient;
  final double blurSigma;
  final double glowBlur;
  final double opacity;

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const GlowBlurCircle({
    super.key,
    required this.width,
    required this.height,
    required this.gradient,
    this.blurSigma = 60,
    this.glowBlur = 80,
    this.opacity = 0.5,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.isBlurred = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget baseCircle = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: gradient),
    );
    final Widget content;

    if (isBlurred) {
      content = Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: width + glowBlur,
            height: height + glowBlur,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.25),
                  blurRadius: glowBlur,
                  spreadRadius: glowBlur / 2,
                ),
              ],
            ),
          ),

          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Opacity(opacity: opacity, child: baseCircle),
          ),
        ],
      );
    } else {
      content = baseCircle;
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: content,
    );
  }
}
