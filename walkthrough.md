# Walkthrough - Articles State Bug Fix

We have successfully diagnosed and resolved the issue where articles were disappearing when navigating between `ArticlesView` and `FavouritesView` or toggling favorites.

## Root Cause Analysis

`ArticlesCubit` is a shared global/feature BLoC instance provided at the root level of the application. Both `ArticlesView` and `FavouritesView` were observing `ArticlesCubit`'s state via `BlocBuilder` without filtering incoming states.
When navigating to `FavouritesView` or `ArticleDetailsView`, these views called `getFavoriteArticles()` or `checkIfArticleIsFavorite()`, causing the shared BLoC to emit `FavoriteArticlesLoaded` or `ArticleIsFavorite`.
Since `ArticlesView` was still active in the background navigation stack, it rebuilt on these states. Because those states were not `AllArticlesLoaded`, its builder fell through and rendered an empty `SizedBox.shrink()`.
Similarly, in `FavouritesView`, deleting a favorite emitted `ArticleRemovedFromFavorites`, which caused the favorites screen to disappear and render a blank page.

## Changes Made

### 1. `ArticlesView`
- **File**: [articles_view.dart](file:///d:/GraduatChildMonitor/lib/features/articles/presentation/view/articles_view.dart)
- **Modifications**:
  - Added a `buildWhen` condition to the `BlocBuilder<ArticlesCubit, ArticlesState>` to ensure it only rebuilds when the state transitions to `AllArticlesLoaded`, `ArticlesError`, or an initial `ArticlesLoading` state. Unrelated states (like checking favorite or favorites loaded) are now ignored, retaining the loaded list perfectly.
  - Pre-captured `ArticlesCubit` as `final articlesCubit = context.read<ArticlesCubit>()` before navigating to the favorites screen. This completely resolved the Flutter linter warning `use_build_context_synchronously` since the `BuildContext` is no longer accessed across the async gap.

### 2. `FavouritesView`
- **File**: [favourites_view.dart](file:///d:/GraduatChildMonitor/lib/features/articles/presentation/view/favourites_view.dart)
- **Modifications**:
  - Wrapped `BlocBuilder` inside a `BlocListener<ArticlesCubit, ArticlesState>` to listen for `ArticleRemovedFromFavorites`. When a favorite is deleted, it triggers `getFavoriteArticles()` to silently and dynamically refresh the favorites list.
  - Added a custom `buildWhen` condition to prevent any background spinner flashing when deleting or performing other actions, keeping the list fully visible while refreshing.

---

## Verification Results

### Static Analysis
We ran `flutter analyze` inside the workspace `d:\GraduatChildMonitor`.
The codebase compiles perfectly:
- **Zero compiler errors.**
- **Zero linter warnings** inside `articles_view.dart` and `favourites_view.dart` (the `use_build_context_synchronously` warning was completely eliminated).
