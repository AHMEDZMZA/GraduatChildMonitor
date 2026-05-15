import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:dio/dio.dart';

abstract class ArticlesRemoteDataSource {
  Future<List<Article>> getAllArticles();

  Future<Article> getArticleDetail(String articleId);

  Future<List<Article>> getArticlesByCategory(String category);

  Future<void> addArticleToFavorite(String articleId);

  Future<void> removeArticleFromFavorite(String articleId);

  Future<List<Article>> getFavoriteArticles();

  Future<bool> checkIfArticleIsFavorite(String articleId);
}

class ArticlesRemoteDataSourceImpl implements ArticlesRemoteDataSource {
  final ApiClient apiClient;

  ArticlesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<Article>> getAllArticles() async {
    try {
      final response = await apiClient.getAllArticles();
      return response.data.articles;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get articles failed: ${e.toString()}');
    }
  }

  @override
  Future<Article> getArticleDetail(String articleId) async {
    try {
      final response = await apiClient.getArticleDetail(articleId);
      return Article(
        id: response.data.id,
        title: response.data.title,
        content: response.data.content,
        image: response.data.image,
        category: response.data.category,
        author: response.data.author,
        publishedDate: response.data.publishedDate,
        description: response.data.description,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get article detail failed: ${e.toString()}');
    }
  }

  @override
  Future<List<Article>> getArticlesByCategory(String category) async {
    try {
      final response = await apiClient.getArticlesByCategory(category);
      return response.data.articles;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get articles by category failed: ${e.toString()}');
    }
  }

  @override
  Future<void> addArticleToFavorite(String articleId) async {
    try {
      await apiClient.addArticleToFavorite(articleId);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Add to favorites failed: ${e.toString()}');
    }
  }

  @override
  Future<void> removeArticleFromFavorite(String articleId) async {
    try {
      await apiClient.removeArticleFromFavorite(articleId);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Remove from favorites failed: ${e.toString()}');
    }
  }

  @override
  Future<List<Article>> getFavoriteArticles() async {
    try {
      final response = await apiClient.getFavoriteArticles();
      return response.data.favorites;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get favorites failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkIfArticleIsFavorite(String articleId) async {
    try {
      final response = await apiClient.checkIfArticleIsFavorite(articleId);
      return response.data.isFavorite;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Check favorite failed: ${e.toString()}');
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return UnauthorizedException(
            message: e.response?.data['message'] ?? 'Unauthorized',
          );
        }
        return ServerException(
          message: e.response?.data['message'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return ServerException(message: 'Request cancelled');
      default:
        return ServerException(message: 'Network error: ${e.message}');
    }
  }
}
