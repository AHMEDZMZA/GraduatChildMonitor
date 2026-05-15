import 'package:child_monitor_app/features/articles/presentation/cubit/articles_cubit.dart';
import 'package:child_monitor_app/features/articles/presentation/state/articles_state.dart';
import 'package:child_monitor_app/features/articles/presentation/widgets/api_article_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../../core/navigation/app_routes.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  @override
  void initState() {
    super.initState();
    context.read<ArticlesCubit>().getFavoriteArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: ColorManager.buttonBlue,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Center(
                      child: CustomText(
                        text: 'Favourites',
                        style: AppTextStyles.nunito32w900Black,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.favorite,
                    color: ColorManager.primaryBlue,
                    size: 30,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Expanded(
                child: BlocBuilder<ArticlesCubit, ArticlesState>(
                  builder: (context, state) {
                    if (state is ArticlesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryBlue,
                        ),
                      );
                    }

                    if (state is ArticlesError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.nunito14w400Grey,
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => context
                                  .read<ArticlesCubit>()
                                  .getFavoriteArticles(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is FavoriteArticlesLoaded) {
                      if (state.favorites.isEmpty) {
                        return const Center(
                          child: Text(
                            'No favourite articles yet.',
                            style: AppTextStyles.nunito14w400Grey,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.favorites.length,
                        itemBuilder: (context, index) {
                          final article = state.favorites[index];
                          return ApiArticleCard(
                            article: article,
                            showDelete: true,
                            onDeleteTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                builder: (_) {
                                  return AppBottomSheet(
                                    title: 'Delete From Favourites',
                                    description:
                                        'Are you sure you want to delete from favourites?',
                                    confirmText: 'Yes, Delete',
                                    onConfirm: () {
                                      Navigator.pop(context);
                                      context
                                          .read<ArticlesCubit>()
                                          .removeArticleFromFavorite(
                                              article.id);
                                    },
                                  );
                                },
                              );
                            },
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.articleDetails,
                                arguments: article,
                              );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
