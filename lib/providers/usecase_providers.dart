// lib/providers/usecase_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain layer imports
import 'package:trelpix/domain/usecases/bookmark/add_bookmark.dart';
import 'package:trelpix/domain/usecases/movie/get_movie_cast.dart';
import 'package:trelpix/domain/usecases/movie/get_movie_details.dart';
import 'package:trelpix/domain/usecases/movie/get_movie_reviews.dart';
import 'package:trelpix/domain/usecases/movie/get_movies.dart';
import 'package:trelpix/domain/usecases/bookmark/is_movie_bookmarked.dart';
import 'package:trelpix/domain/usecases/bookmark/remove_bookmark.dart';
import 'package:trelpix/domain/usecases/movie/search_movies.dart';
import 'package:trelpix/domain/usecases/bookmark/get_bookmarked_movies.dart';
import 'package:trelpix/domain/usecases/image/preload_image.dart';
import 'package:trelpix/domain/usecases/image/get_image_file.dart';

// Import repository providers for dependencies
import 'package:trelpix/providers/repository_providers.dart';

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
