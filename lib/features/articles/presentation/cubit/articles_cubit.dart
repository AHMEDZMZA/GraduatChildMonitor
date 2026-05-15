import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/articles/domain/usecases/articles_usecases.dart';
import 'package:child_monitor_app/features/articles/presentation/state/articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final GetAllArticlesUseCase getAllArticlesUseCase;
  final GetArticleDetailUseCase getArticleDetailUseCase;
  final GetArticlesByCategoryUseCase getArticlesByCategoryUseCase;
  final AddArticleToFavoriteUseCase addArticleToFavoriteUseCase;
  final RemoveArticleFromFavoriteUseCase removeArticleFromFavoriteUseCase;
  final GetFavoriteArticlesUseCase getFavoriteArticlesUseCase;
  final CheckIfArticleIsFavoriteUseCase checkIfArticleIsFavoriteUseCase;

  ArticlesCubit({
    required this.getAllArticlesUseCase,
    required this.getArticleDetailUseCase,
    required this.getArticlesByCategoryUseCase,
    required this.addArticleToFavoriteUseCase,
    required this.removeArticleFromFavoriteUseCase,
    required this.getFavoriteArticlesUseCase,
    required this.checkIfArticleIsFavoriteUseCase,
  }) : super(const ArticlesInitial());

  Future<void> getAllArticles() async {
    emit(const ArticlesLoading());
    final result = await getAllArticlesUseCase.call();

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (articles) => emit(AllArticlesLoaded(articles)),
    );
  }

  Future<void> getArticleDetail(String articleId) async {
    emit(const ArticlesLoading());
    final result = await getArticleDetailUseCase.call(articleId);

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (article) => emit(ArticleDetailLoaded(article)),
    );
  }

  Future<void> getArticlesByCategory(String category) async {
    emit(const ArticlesLoading());
    final result = await getArticlesByCategoryUseCase.call(category);

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (articles) => emit(ArticlesByCategoryLoaded(articles, category)),
    );
  }

  Future<void> addArticleToFavorite(String articleId) async {
    emit(const ArticlesLoading());
    final result = await addArticleToFavoriteUseCase.call(articleId);

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (_) => emit(ArticleAddedToFavorites(articleId)),
    );
  }

  Future<void> removeArticleFromFavorite(String articleId) async {
    emit(const ArticlesLoading());
    final result = await removeArticleFromFavoriteUseCase.call(articleId);

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (_) => emit(ArticleRemovedFromFavorites(articleId)),
    );
  }

  Future<void> getFavoriteArticles() async {
    emit(const ArticlesLoading());
    final result = await getFavoriteArticlesUseCase.call();

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (articles) => emit(FavoriteArticlesLoaded(articles)),
    );
  }

  Future<void> checkIfArticleIsFavorite(String articleId) async {
    final result = await checkIfArticleIsFavoriteUseCase.call(articleId);

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (isFavorite) => emit(ArticleIsFavorite(isFavorite)),
    );
  }
}
