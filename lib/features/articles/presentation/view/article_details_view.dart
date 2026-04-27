import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/article_model.dart';

class ArticleDetailsView extends StatefulWidget {
  final ArticleModel article;

  const ArticleDetailsView({
    super.key,
    required this.article,
  });

  @override
  State<ArticleDetailsView> createState() => _ArticleDetailsViewState();
}

class _ArticleDetailsViewState extends State<ArticleDetailsView> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.article.isFavourite;
  }

  void _toggleFavourite() {
    setState(() {
      isFavourite = !isFavourite;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavourite
              ? 'This article added to favourites.'
              : 'This article removed from favourites.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withValues(alpha: 0.75),
        margin: const EdgeInsets.symmetric(horizontal: 46, vertical: 90),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      image: DecorationImage(
                        image: AssetImage(widget.article.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
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
                  ),

                  Positioned(
                    right: 18,
                    bottom: -22,
                    child: GestureDetector(
                      onTap: _toggleFavourite,
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
                    widget.article.description,
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
    );
  }
}