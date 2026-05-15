import 'package:cached_network_image/cached_network_image.dart';
import 'package:child_monitor_app/features/articles/domain/entities/article_entity.dart';
import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/managers/theme_helper.dart';

/// Reusable article card that works with [ArticleEntity] from the API.
class ApiArticleCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onTap;
  final bool showDelete;
  final VoidCallback? onDeleteTap;

  const ApiArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.showDelete = false,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final placeholderColor =
        context.isDarkMode ? const Color(0xFF333333) : Colors.grey[300];
    final shimmerColor =
        context.isDarkMode ? const Color(0xFF444444) : Colors.grey[400];

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 270,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: shimmerColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
                  article.image != null
                      ? CachedNetworkImage(
                        imageUrl: article.image!,
                        fit: BoxFit.cover,
                        placeholder:
                            (_, __) => Container(color: placeholderColor),
                        errorWidget:
                            (_, __, ___) => Container(color: shimmerColor),
                      )
                      : Container(color: shimmerColor),
            ),
          ),
          Container(
            height: 270,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
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
                    fontSize: 32,
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
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 110),
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
