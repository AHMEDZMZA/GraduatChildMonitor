import 'package:cached_network_image/cached_network_image.dart';
import 'package:child_monitor_app/features/articles/domain/entities/article_entity.dart';
import 'package:child_monitor_app/features/articles/presentation/cubit/articles_cubit.dart';
import 'package:child_monitor_app/features/articles/presentation/state/articles_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleDetailsView extends StatefulWidget {
  final ArticleEntity article;

  const ArticleDetailsView({super.key, required this.article});

  @override
  State<ArticleDetailsView> createState() => _ArticleDetailsViewState();
}

class _ArticleDetailsViewState extends State<ArticleDetailsView> {
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    // Check current favorite status
    context.read<ArticlesCubit>().checkIfArticleIsFavorite(widget.article.id);
  }

  void _toggleFavourite(BuildContext context) {
    if (isFavourite) {
      context.read<ArticlesCubit>().removeArticleFromFavorite(
        widget.article.id,
      );
    } else {
      context.read<ArticlesCubit>().addArticleToFavorite(widget.article.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticlesCubit, ArticlesState>(
      listener: (context, state) {
        if (state is ArticleIsFavorite) {
          setState(() => isFavourite = state.isFavorite);
        } else if (state is ArticleAddedToFavorites) {
          setState(() => isFavourite = true);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('This article added to favourites.'),
              behavior: SnackBarBehavior.floating,
              //backgroundColor: ColorManager.overlayBlack20,
              margin: EdgeInsets.symmetric(horizontal: 46.w, vertical: 90.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is ArticleRemovedFromFavorites) {
          setState(() => isFavourite = false);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('This article removed from favourites.'),
              behavior: SnackBarBehavior.floating,
              // backgroundColor: ColorManager.overlayBlack20,
              margin: EdgeInsets.symmetric(horizontal: 46.w, vertical: 90.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is ArticlesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorManager.errorRed,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 430,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.r),
                          bottomRight: Radius.circular(30.r),
                        ),
                        color: ColorManager.mediumGray,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.r),
                          bottomRight: Radius.circular(30.r),
                        ),
                        child: widget.article.image != null
                            ? CachedNetworkImage(
                                imageUrl: widget.article.image!,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Container(color: ColorManager.lightGray),
                                errorWidget: (_, __, ___) =>
                                    Container(color: ColorManager.mediumGray),
                              )
                            : Container(color: ColorManager.mediumGray),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 430,
                      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.r),
                          bottomRight: Radius.circular(30.r),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorManager.black.withValues(alpha: 0.12),
                            ColorManager.black.withValues(alpha: 0.22),
                            ColorManager.black.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: ColorManager.white,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 14,
                                color: ColorManager.darkText,
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(height: 86.h),
                          Text(
                            widget.article.title,
                            style: AppTextStyles.nunito30w900Black.copyWith(
                              color: ColorManager.white,
                              fontSize: 24.sp,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 18,
                      bottom: -22,
                      child: GestureDetector(
                        onTap: () => _toggleFavourite(context),
                        child: Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: ColorManager.buttonBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorManager.primaryBlue,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: ColorManager.primaryBlue,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Transform.translate(
                  offset: const Offset(0, -2),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(12.w, 28.h, 12.w, 18.h),
                    child: Text(
                      widget.article.description ?? widget.article.content,
                      style: AppTextStyles.nunito14w400Grey.copyWith(
                        color: ColorManager.primaryBlue,
                        fontSize: 14.sp,
                        height: 1.9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
