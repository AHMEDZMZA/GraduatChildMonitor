import 'package:cached_network_image/cached_network_image.dart';
import 'package:child_monitor_app/features/articles/domain/entities/article_entity.dart';
import 'package:child_monitor_app/features/articles/presentation/cubit/articles_cubit.dart';
import 'package:child_monitor_app/features/articles/presentation/state/articles_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';

class ArticleDetailsView extends StatefulWidget {
  final ArticleEntity article;

  const ArticleDetailsView({
    super.key,
    required this.article,
  });

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
      context.read<ArticlesCubit>().removeArticleFromFavorite(widget.article.id);
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
              backgroundColor: Colors.black.withValues(alpha: 0.75),
              margin:
                  const EdgeInsets.symmetric(horizontal: 46, vertical: 90),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
              backgroundColor: Colors.black.withValues(alpha: 0.75),
              margin:
                  const EdgeInsets.symmetric(horizontal: 46, vertical: 90),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is ArticlesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.backgroundWhite,
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
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: Colors.grey[400],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: widget.article.image != null
                            ? CachedNetworkImage(
                                imageUrl: widget.article.image!,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Container(color: Colors.grey[300]),
                                errorWidget: (_, __, ___) =>
                                    Container(color: Colors.grey[400]),
                              )
                            : Container(color: Colors.grey[400]),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 430,
                      padding:
                          const EdgeInsets.fromLTRB(16, 18, 16, 24),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
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
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 86),
                          Text(
                            widget.article.title,
                            style: AppTextStyles.nunito30w900Black.copyWith(
                              color: ColorManager.white,
                              fontSize: 24,
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
                    padding: const EdgeInsets.fromLTRB(12, 28, 12, 18),
                    child: Text(
                      widget.article.description ?? widget.article.content,
                      style: AppTextStyles.nunito14w400Grey.copyWith(
                        color: ColorManager.sloganColor,
                        fontSize: 14,
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