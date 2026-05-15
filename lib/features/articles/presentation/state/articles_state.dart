import 'package:equatable/equatable.dart';
import 'package:child_monitor_app/features/articles/domain/entities/article_entity.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();

  @override
  List<Object?> get props => [];
}

class ArticlesInitial extends ArticlesState {
  const ArticlesInitial();
}

class ArticlesLoading extends ArticlesState {
  const ArticlesLoading();
}

class AllArticlesLoaded extends ArticlesState {
  final List<ArticleEntity> articles;

  const AllArticlesLoaded(this.articles);

  @override
  List<Object?> get props => [articles];
}

class ArticlesByCategoryLoaded extends ArticlesState {
  final List<ArticleEntity> articles;
  final String category;

  const ArticlesByCategoryLoaded(this.articles, this.category);

  @override
  List<Object?> get props => [articles, category];
}

class ArticleDetailLoaded extends ArticlesState {
  final ArticleEntity article;

  const ArticleDetailLoaded(this.article);

  @override
  List<Object?> get props => [article];
}

class FavoriteArticlesLoaded extends ArticlesState {
  final List<ArticleEntity> favorites;

  const FavoriteArticlesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class ArticleIsFavorite extends ArticlesState {
  final bool isFavorite;

  const ArticleIsFavorite(this.isFavorite);

  @override
  List<Object?> get props => [isFavorite];
}

class ArticleAddedToFavorites extends ArticlesState {
  final String articleId;

  const ArticleAddedToFavorites(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

class ArticleRemovedFromFavorites extends ArticlesState {
  final String articleId;

  const ArticleRemovedFromFavorites(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

class ArticlesError extends ArticlesState {
  final String message;

  const ArticlesError(this.message);

  @override
  List<Object?> get props => [message];
}
