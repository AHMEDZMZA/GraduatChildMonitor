import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../data/article_model.dart';
import '../widgets/article_card.dart';
import 'article_details_view.dart';
class FavouritesView extends StatelessWidget {
  const FavouritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ArticleModel> favourites = [
      const ArticleModel(
        title: 'Fugiat consectetur...',
        description:
            'Commodi in et cupiditate aut eligendi. Quo ullam rerum provident sunt deleniti quod et aliquid velit. Velit officia provident accusantium porro deleniti omnis est repellat...',
        image: AppAssets.article,
        isFavourite: true,
      ),
      const ArticleModel(
        title: 'Fugiat consectetur...',
        description:
            'Commodi in et cupiditate aut eligendi. Quo ullam rerum provident sunt deleniti quod et aliquid velit. Velit officia provident accusantium porro deleniti omnis est repellat...',
        image: AppAssets.article,
        isFavourite: true,
      ),
    ];

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
                child: ListView.builder(
                  itemCount: favourites.length,
                  itemBuilder: (context, index) {
                    final article = favourites[index];
                    return ArticleCard(
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
                              description: 'Are you sure you want to delete from favourites?',
                              confirmText: 'Yes,Delete',
                              onConfirm: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticleDetailsView(article: article),
                          ),
                        );
                      },
                    );
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
