# Implementation Plan - Fix Disappearing Articles State Bug

This plan addresses the issue where articles disappear in `ArticlesView` after navigating to `FavouritesView` or toggling favorites in `ArticleDetailsView`.

## Problem Description

`ArticlesCubit` is a shared global/feature BLoC instance provided at the root of the application.
When navigating to `FavouritesView` or `ArticleDetailsView`, these sub-views dispatch events to the same `ArticlesCubit` instance (such as fetching favorites, checking if an article is favorite, or deleting from favorites). 
As a result:
1. The shared `ArticlesCubit` emits new states (`FavoriteArticlesLoaded`, `ArticleIsFavorite`, or `ArticleRemovedFromFavorites`).
2. `ArticlesView` (which is still active in the background navigation stack) receives these new states.
3. Because `ArticlesView` only handles `AllArticlesLoaded` specifically, it falls through to its default return block: `return const SizedBox.shrink()`, rendering a blank screen.
4. When popping back, the screen remains blank because `initState()` is not triggered again on return.

Furthermore, inside `FavouritesView`, deleting a favorite article changes the state to `ArticleRemovedFromFavorites`, which is not handled by `FavouritesView`'s `BlocBuilder`, causing the entire screen to go blank there too.

## Proposed Solution

Instead of refactoring the entire BLoC and State structures (which is highly intrusive and risky), we will implement a standard and extremely elegant Flutter BLoC solution:

1. **`ArticlesView`**:
   - Use `buildWhen` in `BlocBuilder` to only rebuild the UI when the state transitions to `AllArticlesLoaded`, `ArticlesError`, or an initial `ArticlesLoading` state.
   - Capture `articlesCubit` before navigating to `FavouritesView` to avoid context-related async gap warning.
   - Restrict rebuilding on `ArticlesLoading` so that it doesn't flash a loader in the background when other screens initiate loading.

2. **`FavouritesView`**:
   - Use `buildWhen` in `BlocBuilder` to only rebuild the UI when the state is `FavoriteArticlesLoaded`, `ArticlesError`, or an initial `ArticlesLoading`.
   - Wrap the builder with a `BlocListener` to listen for `ArticleRemovedFromFavorites`. When this state is emitted, the listener will call `getFavoriteArticles()` to silently refresh the favorites list.
   - Prevent background spinner flashing by checking the `previous` state before rendering `ArticlesLoading`.

---

## Proposed Changes

### Articles Feature

#### [MODIFY] [articles_view.dart](file:///d:/GraduatChildMonitor/lib/features/articles/presentation/view/articles_view.dart)
- Add `buildWhen` to `BlocBuilder<ArticlesCubit, ArticlesState>` to prevent it from rebuilding into empty states when `ArticlesCubit` is used elsewhere.
- Capture `articlesCubit` before navigating to avoid the lint warning about using `BuildContext` across async gaps.

#### [MODIFY] [favourites_view.dart](file:///d:/GraduatChildMonitor/lib/features/articles/presentation/view/favourites_view.dart)
- Wrap `BlocBuilder` inside a `BlocListener` to detect deletion and trigger refresh.
- Add `buildWhen` to only react to states relevant to the favorites view.

---

## Verification Plan

### Automated / Diagnostic Tests
- Run `flutter analyze` inside the workspace `d:\GraduatChildMonitor` to verify that there are zero compiler or lint issues (including `use_build_context_synchronously`).

### Manual Verification
- Ask the user to run the app and test the navigation:
  1. Open the Articles page (all articles load).
  2. Tap the heart/favourites icon to go to Favourites page (favourites load properly, no empty pages).
  3. Go back to Articles page (articles should be present, not blank).
  4. Open an article's details page and toggle the favorite status, then go back (Articles page should be perfectly intact and not blank).
  5. Delete a favorite article from the Favourites view (the item should disappear smoothly without the screen going blank or flashing a loader).
