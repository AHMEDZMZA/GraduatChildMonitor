// import 'package:flutter/material.dart';
// import '../../../../core/managers/app_text_styles.dart';
// import '../../../../core/managers/color_manager.dart';
// import '../data/article_model.dart';
//
// class ArticleCard extends StatelessWidget {
//   final ArticleModel article;
//   final VoidCallback onTap;
//
//   const ArticleCard({super.key, required this.article, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 270,
//         width: double.infinity,
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(18),
//           image: DecorationImage(
//             image: AssetImage(article.image),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18),
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 ColorManager.black.withValues(alpha: 0.55),
//                 ColorManager.black.withValues(alpha: 0.75),
//               ],
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 article.title,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: AppTextStyles.nunito20w900Black.copyWith(
//                   color: ColorManager.white,
//                   fontSize: 32,
//                 ),
//               ),
//               const Spacer(),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       article.description,
//                       maxLines: 4,
//                       overflow: TextOverflow.ellipsis,
//                       style: AppTextStyles.nunito14w400White.copyWith(
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 110),
//                     height: 28,
//                     width: 28,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: ColorManager.white, width: 1.5),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_forward_ios,
//                       size: 14,
//                       color: ColorManager.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../data/article_model.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;
  final bool showDelete;
  final VoidCallback? onDeleteTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.showDelete = false,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
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
              image: DecorationImage(
                image: AssetImage(article.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
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
                          article.description,
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