import 'package:child_monitor_app/features/articles/presentation/cubit/articles_cubit.dart';
import 'package:child_monitor_app/features/articles/presentation/state/articles_state.dart';
import 'package:child_monitor_app/features/articles/presentation/widgets/api_article_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../../../core/navigation/app_routes.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  @override
  void initState() {
    super.initState();
    context.read<ArticlesCubit>().getAllArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        color: ColorManager.darkText,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Center(
                      child: CustomText(
                        text: 'Articles',
                        style: AppTextStyles.nunito32w900Black,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.favourites);
                    },
                    child: const Icon(
                      Icons.favorite_border,
                      color: ColorManager.primaryBlue,
                      size: 30,
                    ),
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
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: ColorManager.errorRed,
                            ),
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
                                  .getAllArticles(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is AllArticlesLoaded) {
                      if (state.articles.isEmpty) {
                        return const Center(
                          child: Text(
                            'No articles available.',
                            style: AppTextStyles.nunito14w400Grey,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) {
                          final article = state.articles[index];
                          return ApiArticleCard(
                            article: article,
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
