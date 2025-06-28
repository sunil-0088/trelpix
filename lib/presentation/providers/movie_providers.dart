import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trelpix/core/network/tmdb_api_client.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';
import 'package:trelpix/domain/entities/cast.dart';
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/entities/review.dart';
import 'package:trelpix/domain/enums/movie_category.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final tmdbApiClientProvider = Provider<TmdbApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return TmdbApiClient(dio);
});

final hiveBoxesProvider = FutureProvider<Map<String, Box>>((ref) async {
  final Map<String, Box> boxes = {};
  boxes['trending_movies'] = await Hive.openBox<MovieModel>('trending_movies');
  boxes['now_playing_movies'] = await Hive.openBox<MovieModel>(
    'now_playing_movies',
  );
  boxes['top_rated_movies'] = await Hive.openBox<MovieModel>(
    'top_rated_movies',
  );
  boxes['bookmarked_movies'] = await Hive.openBox<MovieModel>(
    'bookmarked_movies',
  );
  boxes['movie_details'] = await Hive.openBox<MovieDetailsModel>(
    'movie_details',
  );
  boxes['movie_credits'] = await Hive.openBox<CreditsResponseModel>(
    'movie_credits',
  );
  boxes['movie_reviews'] = await Hive.openBox<ReviewsResponseModel>(
    'movie_reviews',
  );
  boxes['cache_timestamps'] = await Hive.openBox<int>('cache_timestamps');
  return boxes;
});

final movieRepositoryProvider = FutureProvider<MovieRepository>((ref) async {
  final apiClient = ref.watch(tmdbApiClientProvider);
  final boxes = await ref.watch(hiveBoxesProvider.future);

  return MovieRepository(
    apiClient,
    boxes['trending_movies']! as Box<MovieModel>,
    boxes['now_playing_movies']! as Box<MovieModel>,
    boxes['top_rated_movies']! as Box<MovieModel>,
    boxes['bookmarked_movies']! as Box<MovieModel>,
    boxes['movie_details']! as Box<MovieDetailsModel>,
    boxes['movie_credits']! as Box<CreditsResponseModel>,
    boxes['movie_reviews']! as Box<ReviewsResponseModel>,
    boxes['cache_timestamps']! as Box<int>,
  );
});

final trendingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final repository = await ref.watch(movieRepositoryProvider.future);
  return await repository.getMovies(MovieCategory.trending);
});

final nowPlayingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final repository = await ref.watch(movieRepositoryProvider.future);
  return await repository.getMovies(MovieCategory.nowPlaying);
});

final topRatedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final repository = await ref.watch(movieRepositoryProvider.future);
  return await repository.getMovies(MovieCategory.topRated);
});

final movieDetailsProvider = FutureProvider.family<MovieDetails?, int>((
  ref,
  movieId,
) async {
  final repository = await ref.watch(movieRepositoryProvider.future);
  return await repository.getMovieDetails(movieId);
});

final movieCastProvider = FutureProvider.family<List<Cast>, int>((
  ref,
  movieId,
) async {
  final repository = await ref.watch(movieRepositoryProvider.future);
  return await repository.getMovieCast(movieId);
});

final movieReviewsProvider = FutureProvider.family<List<Review>, int>((
  ref,
  movieId,
) async {
  final repository = await ref.watch(movieRepositoryProvider.future);
  return await repository.getMovieReviews(movieId);
});

final searchMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, AsyncValue<List<Movie>>>((ref) {
      final repository = ref.watch(movieRepositoryProvider);
      return SearchMoviesNotifier(ref, repository);
    });

class SearchMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final Ref ref;
  final AsyncValue<MovieRepository> repoAsync;

  SearchMoviesNotifier(this.ref, this.repoAsync)
    : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final repository = await ref.read(movieRepositoryProvider.future);
      final movies = await repository.searchMovies(query);
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
  final bookmarks = ref.watch(bookmarkedMoviesProvider);
  return bookmarks.when(
    data: (movies) => movies.any((movie) => movie.id == movieId),
    loading: () => false,
    error: (err, stack) => false,
  );
});

final bookmarkedMoviesProvider =
    StateNotifierProvider<BookmarkedMoviesNotifier, AsyncValue<List<Movie>>>((
      ref,
    ) {
      final repository = ref.watch(movieRepositoryProvider);
      return BookmarkedMoviesNotifier(repository);
    });

class BookmarkedMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final AsyncValue<MovieRepository> repoAsync;

  BookmarkedMoviesNotifier(this.repoAsync) : super(const AsyncValue.loading()) {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    state = const AsyncValue.loading();
    try {
      final bookmarks = await repoAsync.value!.getBookmarkedMovies();
      state = AsyncValue.data(bookmarks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBookmark(Movie movie) async {
    await repoAsync.value!.addBookmark(movie);
    state = AsyncValue.data(await repoAsync.value!.getBookmarkedMovies());
  }

  Future<void> removeBookmark(int movieId) async {
    await repoAsync.value!.removeBookmark(movieId);
    state = AsyncValue.data(await repoAsync.value!.getBookmarkedMovies());
  }
}
