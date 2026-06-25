import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(
          image: AssetImage(AppAssets.banner),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}