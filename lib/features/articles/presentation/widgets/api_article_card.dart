import 'package:cached_network_image/cached_network_image.dart';
import 'package:child_monitor_app/features/articles/domain/entities/article_entity.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/managers/theme_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable article card that works with [ArticleEntity] from the API.
class ApiArticleCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onTap;
  final bool showDelete;
  final VoidCallback? onDeleteTap;
  final int index;

  const ApiArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.showDelete = false,
    this.onDeleteTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final placeholderColor = context.isDarkMode
        ? const Color(0xFF333333)
        : ColorManager.lightGray;
    final shimmerColor = context.isDarkMode
        ? const Color(0xFF444444)
        : ColorManager.mediumGray;

    final fallbackImages = [
      AppAssets.activities1,
      AppAssets.activities2,
      AppAssets.activities3,
    ];
    final fallbackImage = fallbackImages[index % fallbackImages.length];

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 270,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              color: shimmerColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: article.image != null && article.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: article.image!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: placeholderColor),
                      errorWidget: (_, __, ___) =>
                          Image.asset(fallbackImage, fit: BoxFit.cover),
                    )
                  : Image.asset(fallbackImage, fit: BoxFit.cover),
            ),
          ),
          Container(
            height: 270,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 14.w, 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorManager.black.withValues(alpha: 0.55),
                  ColorManager.black.withValues(alpha: 0.75),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.nunito20w900Black.copyWith(
                    color: ColorManager.white,
                    fontSize: 32.sp,
                  ),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        article.description ?? article.content,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.nunito14w400White.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 110.h),
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorManager.white,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: ColorManager.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showDelete)
            Positioned(
              top: 24,
              right: 12,
              child: GestureDetector(
                onTap: onDeleteTap,
                child: const Icon(
                  Icons.delete,
                  color: ColorManager.white,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
