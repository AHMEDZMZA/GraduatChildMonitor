import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/articles/domain/entities/article_entity.dart';
import 'package:child_monitor_app/features/articles/domain/repositories/articles_repository.dart';

class GetAllArticlesUseCase {
  final ArticlesRepository repository;

  GetAllArticlesUseCase({required this.repository});

  Future<Either<Failure, List<ArticleEntity>>> call() {
    return repository.getAllArticles();
  }
}

class GetArticleDetailUseCase {
  final ArticlesRepository repository;

  GetArticleDetailUseCase({required this.repository});

  Future<Either<Failure, ArticleEntity>> call(String articleId) {
    return repository.getArticleDetail(articleId);
  }
}

class GetArticlesByCategoryUseCase {
  final ArticlesRepository repository;

  GetArticlesByCategoryUseCase({required this.repository});

  Future<Either<Failure, List<ArticleEntity>>> call(String category) {
    return repository.getArticlesByCategory(category);
  }
}

class AddArticleToFavoriteUseCase {
  final ArticlesRepository repository;

  AddArticleToFavoriteUseCase({required this.repository});

  Future<Either<Failure, void>> call(String articleId) {
    return repository.addArticleToFavorite(articleId);
  }
}

class RemoveArticleFromFavoriteUseCase {
  final ArticlesRepository repository;

  RemoveArticleFromFavoriteUseCase({required this.repository});

  Future<Either<Failure, void>> call(String articleId) {
    return repository.removeArticleFromFavorite(articleId);
  }
}

class GetFavoriteArticlesUseCase {
  final ArticlesRepository repository;

  GetFavoriteArticlesUseCase({required this.repository});

  Future<Either<Failure, List<ArticleEntity>>> call() {
    return repository.getFavoriteArticles();
  }
}

class CheckIfArticleIsFavoriteUseCase {
  final ArticlesRepository repository;

  CheckIfArticleIsFavoriteUseCase({required this.repository});

  Future<Either<Failure, bool>> call(String articleId) {
    return repository.checkIfArticleIsFavorite(articleId);
  }
}
