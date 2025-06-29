import 'package:hive/hive.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart'
    show MovieDetailsModel;

import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';
import 'package:trelpix/domain/enums/movie_category.dart';

const int CACHE_DURATION_HOURS = 2;

class MovieLocalDataSource {
  final Box<MovieModel> trendingBox;
  final Box<MovieModel> nowPlayingBox;
  final Box<MovieModel> topRatedBox;
  final Box<MovieModel> bookmarkedBox;
  final Box<MovieDetailsModel> detailsBox;
  final Box<CreditsResponseModel> creditsBox;
  final Box<ReviewsResponseModel> reviewsBox;
  final Box<int> cacheTimestampsBox;

  MovieLocalDataSource({
    required this.trendingBox,
    required this.nowPlayingBox,
    required this.topRatedBox,
    required this.bookmarkedBox,
    required this.detailsBox,
    required this.creditsBox,
    required this.reviewsBox,
    required this.cacheTimestampsBox,
  });

  // --- Movie List Caching ---
  Future<List<MovieModel>> getMovies(MovieCategory category) async {
    Box<MovieModel> box;
    switch (category) {
      case MovieCategory.trending:
        box = trendingBox;
        break;
      case MovieCategory.nowPlaying:
        box = nowPlayingBox;
        break;
      case MovieCategory.topRated:
        box = topRatedBox;
        break;
    }
    return box.values.toList();
  }

  Future<void> putMovies(
    MovieCategory category,
    List<MovieModel> movies,
  ) async {
    Box<MovieModel> box;
    switch (category) {
      case MovieCategory.trending:
        box = trendingBox;
        break;
      case MovieCategory.nowPlaying:
        box = nowPlayingBox;
        break;
      case MovieCategory.topRated:
        box = topRatedBox;
        break;
    }
    await box.clear(); // Clear existing data
    await box.addAll(movies);
    await setCacheTimestamp(category.toString()); // Update timestamp
  }

  Future<bool> isCacheStale(MovieCategory category) async {
    final key = category.toString();
    final timestamp = cacheTimestampsBox.get(key);
    if (timestamp == null) {
      return true; // No timestamp, so cache is stale
    }
    final lastCached = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(lastCached).inHours >= CACHE_DURATION_HOURS;
  }

  Future<void> setCacheTimestamp(String key) async {
    await cacheTimestampsBox.put(key, DateTime.now().millisecondsSinceEpoch);
  }

  // --- Movie Details Caching ---
  Future<MovieDetailsModel?> getMovieDetails(int movieId) async {
    return detailsBox.get(movieId);
  }

  Future<void> putMovieDetails(MovieDetailsModel details) async {
    await detailsBox.put(details.id, details);
  }

  // --- Movie Cast Caching ---
  Future<CreditsResponseModel?> getMovieCast(int movieId) async {
    return creditsBox.get(movieId);
  }

  Future<void> putMovieCast(int movieId, CreditsResponseModel credits) async {
    await creditsBox.put(movieId, credits);
  }

  // --- Movie Reviews Caching ---
  Future<ReviewsResponseModel?> getMovieReviews(int movieId) async {
    return reviewsBox.get(movieId);
  }

  Future<void> putMovieReviews(
    int movieId,
    ReviewsResponseModel reviews,
  ) async {
    await reviewsBox.put(movieId, reviews);
  }

  // --- Bookmarks ---
  Future<List<MovieModel>> getBookmarkedMovies() async {
    return bookmarkedBox.values.toList();
  }

  Future<void> addBookmark(MovieModel movie) async {
    await bookmarkedBox.put(movie.id, movie);
  }

  Future<void> removeBookmark(int movieId) async {
    await bookmarkedBox.delete(movieId);
  }

  Future<bool> isMovieBookmarked(int movieId) async {
    return bookmarkedBox.containsKey(movieId);
  }
}
