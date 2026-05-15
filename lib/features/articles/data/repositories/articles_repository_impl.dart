import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:child_monitor_app/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:child_monitor_app/features/articles/domain/entities/article_entity.dart';
import 'package:child_monitor_app/features/articles/domain/repositories/articles_repository.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesRemoteDataSource remoteDataSource;

  ArticlesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ArticleEntity>>> getAllArticles() async {
    try {
      final articles = await remoteDataSource.getAllArticles();
      return Right(
        articles
            .map((article) => ArticleEntity(
                  id: article.id,
                  title: article.title,
                  content: article.content,
                  image: article.image,
                  category: article.category,
                  author: article.author,
                  publishedDate: article.publishedDate,
                  description: article.description,
                ))
            .toList(),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleEntity>> getArticleDetail(String articleId) async {
    try {
      final article = await remoteDataSource.getArticleDetail(articleId);
      return Right(
        ArticleEntity(
          id: article.id,
          title: article.title,
          content: article.content,
          image: article.image,
          category: article.category,
          author: article.author,
          publishedDate: article.publishedDate,
          description: article.description,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getArticlesByCategory(String category) async {
    try {
      final articles = await remoteDataSource.getArticlesByCategory(category);
      return Right(
        articles
            .map((article) => ArticleEntity(
                  id: article.id,
                  title: article.title,
                  content: article.content,
                  image: article.image,
                  category: article.category,
                  author: article.author,
                  publishedDate: article.publishedDate,
                  description: article.description,
                ))
            .toList(),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addArticleToFavorite(String articleId) async {
    try {
      await remoteDataSource.addArticleToFavorite(articleId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeArticleFromFavorite(String articleId) async {
    try {
      await remoteDataSource.removeArticleFromFavorite(articleId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getFavoriteArticles() async {
    try {
      final articles = await remoteDataSource.getFavoriteArticles();
      return Right(
        articles
            .map((article) => ArticleEntity(
                  id: article.id,
                  title: article.title,
                  content: article.content,
                  image: article.image,
                  category: article.category,
                  author: article.author,
                  publishedDate: article.publishedDate,
                  description: article.description,
                ))
            .toList(),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkIfArticleIsFavorite(String articleId) async {
    try {
      final isFavorite = await remoteDataSource.checkIfArticleIsFavorite(articleId);
      return Right(isFavorite);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
