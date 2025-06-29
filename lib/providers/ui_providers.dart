// lib/providers/ui_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain layer imports
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/domain/enums/movie_category.dart';
import 'package:trelpix/domain/usecases/movie/search_movies.dart';
import 'package:trelpix/domain/usecases/bookmark/add_bookmark.dart';
import 'package:trelpix/domain/usecases/bookmark/get_bookmarked_movies.dart';
import 'package:trelpix/domain/usecases/bookmark/remove_bookmark.dart';
import 'package:trelpix/domain/usecases/image/preload_image.dart';

// Import use case providers for dependencies
import 'package:trelpix/providers/usecase_providers.dart';

/* ===========================================================================
   Level 5: UI Consumable Providers (uses only Use Cases)
   =========================================================================== */

// These providers remain exactly the same as they already depend on Use Cases.

final trendingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final getMovies = ref.watch(getMoviesUseCaseProvider);
  final preloadImage = ref.watch(preloadImageUseCaseProvider);
  final movies = await getMovies(MovieCategory.trending);
  for (final movie in movies) {
    if (movie.fullPosterUrl != null) {
      preloadImage(movie.fullPosterUrl!);
    }
  }
  return movies;
});

final nowPlayingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final getMovies = ref.watch(getMoviesUseCaseProvider);
  final preloadImage = ref.watch(preloadImageUseCaseProvider);
  final movies = await getMovies(MovieCategory.nowPlaying);
  for (final movie in movies) {
    if (movie.fullPosterUrl != null) {
      preloadImage(movie.fullPosterUrl!);
    }
  }
  return movies;
});

final topRatedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final getMovies = ref.watch(getMoviesUseCaseProvider);
  final preloadImage = ref.watch(preloadImageUseCaseProvider);
  final movies = await getMovies(MovieCategory.topRated);
  for (final movie in movies) {
    if (movie.fullPosterUrl != null) {
      preloadImage(movie.fullPosterUrl!);
    }
  }
  return movies;
});

final movieDetailsProvider = FutureProvider.family<MovieDetails?, int>((
  ref,
  movieId,
) async {
  final getMovieDetails = ref.watch(getMovieDetailsUseCaseProvider);
  final getMovieCast = ref.watch(getMovieCastUseCaseProvider);
  final getMovieReviews = ref.watch(getMovieReviewsUseCaseProvider);
  final preloadImage = ref.watch(preloadImageUseCaseProvider);

  final details = await getMovieDetails(movieId);

  final cast = await getMovieCast(movieId);
  final reviews = await getMovieReviews(movieId);

  final completeDetails = details.copyWith(casts: cast, reviews: reviews);

  if (completeDetails.fullBackdropUrl != null) {
    preloadImage(completeDetails.fullBackdropUrl!);
  }
  for (final c in cast) {
    if (c.fullProfileUrl != null) preloadImage(c.fullProfileUrl!);
  }
  for (final r in reviews) {
    if (r.authorDetails?.fullAvatarUrl != null) {
      preloadImage(r.authorDetails!.fullAvatarUrl!);
    }
  }

  return completeDetails;
});

final searchMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, AsyncValue<List<Movie>>>((ref) {
      final searchMoviesUseCase = ref.watch(searchMoviesUseCaseProvider);
      return SearchMoviesNotifier(searchMoviesUseCase);
    });

class SearchMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final SearchMovies _searchMovies;

  SearchMoviesNotifier(this._searchMovies) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final movies = await _searchMovies(query);
      state = AsyncValue.data(movies);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final isBookmarkedProvider = FutureProvider.family<bool, int>((
  ref,
  movieId,
) async {
  // It should query the use case directly, not watch the full list provider.
  final isMovieBookmarkedUseCase = ref.watch(isMovieBookmarkedUseCaseProvider);
  return await isMovieBookmarkedUseCase(movieId);
});

final bookmarkedMoviesProvider =
    StateNotifierProvider<BookmarkedMoviesNotifier, AsyncValue<List<Movie>>>((
      ref,
    ) {
      final getBookmarkedMovies = ref.watch(getBookmarkedMoviesUseCaseProvider);
      final addBookmark = ref.watch(addBookmarkUseCaseProvider);
      final removeBookmark = ref.watch(removeBookmarkUseCaseProvider);
      final preloadImage = ref.watch(preloadImageUseCaseProvider);

      return BookmarkedMoviesNotifier(
        getBookmarkedMovies,
        addBookmark,
        removeBookmark,
        preloadImage,
        ref, // Keep ref to invalidate other providers
      );
    });

class BookmarkedMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final GetBookmarkedMovies _getBookmarkedMovies;
  final AddBookmark _addBookmark;
  final RemoveBookmark _removeBookmark;
  final PreloadImage _preloadImage;
  final Ref _ref; // To invalidate other providers

  BookmarkedMoviesNotifier(
    this._getBookmarkedMovies,
    this._addBookmark,
    this._removeBookmark,
    this._preloadImage,
    this._ref,
  ) : super(const AsyncValue.loading()) {
    _loadBookmarks(); // Initial load
  }

  Future<void> _loadBookmarks() async {
    state = const AsyncValue.loading();
    try {
      final bookmarks = await _getBookmarkedMovies();
      for (final movie in bookmarks) {
        if (movie.fullPosterUrl != null) {
          _preloadImage(movie.fullPosterUrl!);
        }
      }
      state = AsyncValue.data(bookmarks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBookmark(Movie movie) async {
    // Optimistic UI update (optional, but good for responsiveness)
    if (state.hasValue) {
      final currentList = state.value!;
      if (!currentList.any((m) => m.id == movie.id)) {
        state = AsyncValue.data([...currentList, movie]);
      }
    } else {
      // If state is not ready, go to loading and reload
      state = const AsyncValue.loading();
    }

    try {
      await _addBookmark(movie); // Execute the use case
      _ref.invalidate(
        isBookmarkedProvider(movie.id),
      ); // Invalidate the single movie status
      await _loadBookmarks(); // Ensure the full list is accurate
    } catch (e, st) {
      // Revert optimistic update or show error
      state = AsyncValue.error(e, st); // Handle error
      await _loadBookmarks(); // Attempt to reload to reflect actual state
    }
  }

  Future<void> removeBookmark(int movieId) async {
    // Optimistic UI update (optional)
    if (state.hasValue) {
      final currentList = state.value!;
      state = AsyncValue.data(
        currentList.where((m) => m.id != movieId).toList(),
      );
    } else {
      state = const AsyncValue.loading();
    }

    try {
      await _removeBookmark(movieId); // Execute the use case
      _ref.invalidate(
        isBookmarkedProvider(movieId),
      ); // Invalidate the single movie status
      await _loadBookmarks(); // Ensure the full list is accurate
    } catch (e, st) {
      // Revert optimistic update or show error
      state = AsyncValue.error(e, st); // Handle error
      await _loadBookmarks(); // Attempt to reload to reflect actual state
    }
  }
}
