import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/articles/domain/entities/article_entity.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<ArticleEntity>>> getAllArticles();

  Future<Either<Failure, ArticleEntity>> getArticleDetail(String articleId);

  Future<Either<Failure, List<ArticleEntity>>> getArticlesByCategory(String category);

  Future<Either<Failure, void>> addArticleToFavorite(String articleId);

  Future<Either<Failure, void>> removeArticleFromFavorite(String articleId);

  Future<Either<Failure, List<ArticleEntity>>> getFavoriteArticles();

  Future<Either<Failure, bool>> checkIfArticleIsFavorite(String articleId);
}
