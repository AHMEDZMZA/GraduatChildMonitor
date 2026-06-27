import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/activity_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityListItem extends StatelessWidget {
  final ActivityModel item;
  final VoidCallback onTap;

  const ActivityListItem({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(15.r),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: item.highlighted
                ? ColorManager.primaryBlue
                : Colors.transparent,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black8,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: item.image.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: item.image,
                      width: 103.w,
                      height: 103.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 103.w,
                        height: 103.w,
                        color: Theme.of(context).cardColor,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        AppAssets.activities1,
                        width: 103.w,
                        height: 103.w,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      item.image.isNotEmpty ? item.image : AppAssets.activities1,
                      width: 103.w,
                      height: 103.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        AppAssets.activities1,
                        width: 103.w,
                        height: 103.w,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.nunito16w900Black.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  if (item.completed) ...[
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 15,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Completed',
                          style: AppTextStyles.nunito12w600overlayGray66
                              .copyWith(
                                color: ColorManager.brightTeal,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}
