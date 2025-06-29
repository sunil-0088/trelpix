// lib/providers.dart
import 'dart:io'; // For File
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core network/data layer imports
import 'package:trelpix/core/network/tmdb_api_client.dart';
import 'package:trelpix/data/datasources/local/movie_local_datasource.dart';
import 'package:trelpix/data/datasources/remote/movie_remote_datasource.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';
import 'package:trelpix/data/repositories/movie_repository_impl.dart';

// Image caching imports
import 'package:trelpix/data/services/image_cache_service.dart';
import 'package:trelpix/data/repositories/image_repository_impl.dart';

// Domain layer imports
import 'package:trelpix/domain/entities/cast.dart';
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/domain/entities/review.dart';
import 'package:trelpix/domain/enums/movie_category.dart';
import 'package:trelpix/domain/repositories/movie_repository.dart'; // Still needed for MovieRepositoryImpl to implement
import 'package:trelpix/domain/repositories/cached_image_repositoy.dart';

// Movie Use Cases
import 'package:trelpix/domain/usecases/bookmark/add_bookmark.dart';
import 'package:trelpix/domain/usecases/movie/get_movie_cast.dart';
import 'package:trelpix/domain/usecases/movie/get_movie_details.dart';
import 'package:trelpix/domain/usecases/movie/get_movie_reviews.dart';
import 'package:trelpix/domain/usecases/movie/get_movies.dart';
import 'package:trelpix/domain/usecases/bookmark/is_movie_bookmarked.dart';
import 'package:trelpix/domain/usecases/bookmark/remove_bookmark.dart';
import 'package:trelpix/domain/usecases/movie/search_movies.dart';

// Bookmark Use Cases
import 'package:trelpix/domain/usecases/bookmark/get_bookmarked_movies.dart';

// Image Use Cases
import 'package:trelpix/domain/usecases/image/preload_image.dart';
import 'package:trelpix/domain/usecases/image/get_image_file.dart';

/* ===========================================================================
   Level 1: Core Dependencies (Dio, Hive, API Client, ImageCacheService)
   =========================================================================== */

final dioProvider = Provider<Dio>((ref) => Dio());

final tmdbApiClientProvider = Provider<TmdbApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return TmdbApiClient(dio);
});

final hiveBoxesProvider = FutureProvider<Map<String, Box>>((ref) async {
  final Map<String, Box> boxes = {
    'trending_movies': await Hive.openBox<MovieModel>('trending_movies'),
    'now_playing_movies': await Hive.openBox<MovieModel>('now_playing_movies'),
    'top_rated_movies': await Hive.openBox<MovieModel>('top_rated_movies'),
    'bookmarked_movies': await Hive.openBox<MovieModel>('bookmarked_movies'),
    'movie_details': await Hive.openBox<MovieDetailsModel>('movie_details'),
    'movie_credits': await Hive.openBox<CreditsResponseModel>('movie_credits'),
    'movie_reviews': await Hive.openBox<ReviewsResponseModel>('movie_reviews'),
    'cache_timestamps': await Hive.openBox<int>('cache_timestamps'),
  };
  return boxes;
});

final imageCacheServiceProvider = Provider<ImageCacheService>((ref) {
  final dio = ref.watch(dioProvider);
  return ImageCacheService(dio);
});

/* ===========================================================================
   Level 2: Data Sources (Concrete Implementations)
   =========================================================================== */

// Providing the concrete implementation directly
final movieRemoteDataSourceProvider = Provider<MovieRemoteDataSource>((ref) {
  final apiClient = ref.watch(tmdbApiClientProvider);
  return MovieRemoteDataSource(apiClient);
});

// Providing the concrete implementation directly (still FutureProvider as it depends on hiveBoxesProvider.future)
final movieLocalDataSourceProvider = FutureProvider<MovieLocalDataSource>((
  ref,
) async {
  final boxes = await ref.watch(hiveBoxesProvider.future);
  return MovieLocalDataSource(
    trendingBox: boxes['trending_movies']! as Box<MovieModel>,
    nowPlayingBox: boxes['now_playing_movies']! as Box<MovieModel>,
    topRatedBox: boxes['top_rated_movies']! as Box<MovieModel>,
    bookmarkedBox: boxes['bookmarked_movies']! as Box<MovieModel>,
    detailsBox: boxes['movie_details']! as Box<MovieDetailsModel>,
    creditsBox: boxes['movie_credits']! as Box<CreditsResponseModel>,
    reviewsBox: boxes['movie_reviews']! as Box<ReviewsResponseModel>,
    cacheTimestampsBox: boxes['cache_timestamps']! as Box<int>,
  );
});

/* ===========================================================================
   Level 3: Repository Implementations (as Interfaces)
   =========================================================================== */

// movieRepositoryProvider now directly injects the concrete data source implementations
final movieRepositoryProvider = Provider<IMovieRepository>((ref) {
  final remoteDataSource = ref.watch(movieRemoteDataSourceProvider);
  final localDataSourceAsync = ref.watch(movieLocalDataSourceProvider);

  // Still use .when for localDataSourceAsync as it's a FutureProvider
  return localDataSourceAsync.when(
    data:
        (localDataSource) => MovieRepositoryImpl(
          remote: remoteDataSource,
          local: localDataSource,
        ),
    loading: () => throw Exception('MovieLocalDataSource not ready'),
    error:
        (err, st) => throw Exception('Failed to load local data source: $err'),
  );
});

final imageRepositoryProvider = Provider<ICachedImageRepository>((ref) {
  final imageCacheService = ref.watch(imageCacheServiceProvider);
  return ImageRepositoryImpl(imageCacheService: imageCacheService);
});

/* ===========================================================================
   Level 4: Use Cases (These are the direct "actions" for the UI)
   =========================================================================== */

// All Use Case providers remain exactly the same, as they depend on IMovieRepository
// which is still an interface, ensuring domain layer abstraction.

final getMoviesUseCaseProvider = Provider<GetMovies>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetMovies(repository);
});

final getMovieDetailsUseCaseProvider = Provider<GetMovieDetails>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetMovieDetails(repository);
});

final getMovieCastUseCaseProvider = Provider<GetMovieCast>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetMovieCast(repository);
});

final getMovieReviewsUseCaseProvider = Provider<GetMovieReviews>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetMovieReviews(repository);
});

final searchMoviesUseCaseProvider = Provider<SearchMovies>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return SearchMovies(repository);
});

final getBookmarkedMoviesUseCaseProvider = Provider<GetBookmarkedMovies>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetBookmarkedMovies(repository);
});

final addBookmarkUseCaseProvider = Provider<AddBookmark>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return AddBookmark(repository);
});

final removeBookmarkUseCaseProvider = Provider<RemoveBookmark>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return RemoveBookmark(repository);
});

final isMovieBookmarkedUseCaseProvider = Provider<IsMovieBookmarked>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return IsMovieBookmarked(repository);
});

final preloadImageUseCaseProvider = Provider<PreloadImage>((ref) {
  final repository = ref.watch(imageRepositoryProvider);
  return PreloadImage(repository);
});

final getImageFileUseCaseProvider = Provider<GetImageFile>((ref) {
  final repository = ref.watch(imageRepositoryProvider);
  return GetImageFile(repository);
});

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
  final isMovieBookmarkedUseCase = ref.watch(isMovieBookmarkedUseCaseProvider);
  ref.watch(bookmarkedMoviesProvider);
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
        ref,
      );
    });

class BookmarkedMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final GetBookmarkedMovies _getBookmarkedMovies;
  final AddBookmark _addBookmark;
  final RemoveBookmark _removeBookmark;
  final PreloadImage _preloadImage;
  final Ref _ref;

  BookmarkedMoviesNotifier(
    this._getBookmarkedMovies,
    this._addBookmark,
    this._removeBookmark,
    this._preloadImage,
    this._ref,
  ) : super(const AsyncValue.loading()) {
    _loadBookmarks();
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
    await _addBookmark(movie);
    _ref.invalidate(isBookmarkedProvider(movie.id));
    await _loadBookmarks();
  }

  Future<void> removeBookmark(int movieId) async {
    await _removeBookmark(movieId);
    _ref.invalidate(isBookmarkedProvider(movieId));
    await _loadBookmarks();
  }
}
