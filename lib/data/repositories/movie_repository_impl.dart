import 'dart:async';

import 'package:logger/logger.dart';
import 'package:trelpix/data/datasources/local/movie_local_datasource.dart';
import 'package:trelpix/data/datasources/remote/movie_remote_datasource.dart';
import 'package:trelpix/data/mappers/movie_mapper.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/services/image_cache_service.dart';
import 'package:trelpix/domain/entities/cast.dart';
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/domain/entities/review.dart';
import 'package:trelpix/domain/enums/movie_category.dart';
import 'package:trelpix/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements IMovieRepository {
  final MovieLocalDataSource local;
  final MovieRemoteDataSource remote;
  final ImageCacheService imageCacheService;
  final Logger _logger = Logger();
  MovieRepositoryImpl({
    required this.local,
    required this.remote,
    required this.imageCacheService,
  });

  @override
  Future<List<Movie>> getMovies(MovieCategory category) async {
    try {
      final isStale = await local.isCacheStale(category);
      // if (!isStale) {
      //   final localMovies = await local.getMovies(category);
      //   if (localMovies.isNotEmpty) {
      //     _logger.d('Serving ${category.name} movies from local cache.');

      //     return localMovies.map((model) => model.toEntity()).toList();
      //   }
      // }

      _logger.d('Fetching ${category.name} movies from remote.');
      // MovieRemoteDataSource now directly returns List<MovieModel> by parsing MoviesResponseModel
      List<MovieModel> remoteMovies;
      switch (category) {
        case MovieCategory.trending:
          remoteMovies = await remote.getTrendingMovies();
          break;
        case MovieCategory.nowPlaying:
          remoteMovies = await remote.getNowPlayingMovies();
          break;
        case MovieCategory.topRated:
          remoteMovies = await remote.getTopRatedMovies();
          break;
      }
      Future.microtask(() {
        for (final movie in remoteMovies) {
          () async {
            _logger.d('Preloading image and movie Details: ${movie.title}');
            final details = await getMovieDetails(movie.id);
            if (details.fullBackdropUrl != null) {
              await imageCacheService.downloadAndCacheImage(
                details.fullBackdropUrl!,
              );
            }
          }();
        }
      });

      await local.putMovies(category, remoteMovies);

      return remoteMovies.map((model) => model.toEntity()).toList();
    } catch (e) {
      _logger.d('Error getting ${category.name} movies: $e');
      final localMovies = await local.getMovies(category);
      if (localMovies.isNotEmpty) {
        _logger.d(
          'Serving ${category.name} movies from stale local cache due to error.',
        );
        return localMovies.map((model) => model.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      // Remote returns List<MovieModel>
      final remoteMovies = await remote.searchMovies(query, page: page);
      return remoteMovies.map((model) => model.toEntity()).toList();
    } catch (e) {
      _logger.d('Error searching movies: $e');
      rethrow;
    }
  }

  @override
  Future<MovieDetails> getMovieDetails(int movieId) async {
    try {
      final localDetails = await local.getMovieDetails(movieId);
      final localCredits = await local.getMovieCast(movieId);
      final localReviewsResponse = await local.getMovieReviews(
        movieId,
      ); // Get the full response model

      if (localDetails != null &&
          localCredits != null &&
          localReviewsResponse != null) {
        _logger.d('Serving full movie details for $movieId from local cache.');
        return localDetails.toEntity(
          casts: localCredits.toCastList(),
          reviews: localReviewsResponse.toReviewList(), // Extract results here
        );
      }

      _logger.d('Fetching full movie details for $movieId from remote.');
      final remoteDetails = await remote.getMovieDetails(movieId);
      final remoteCredits = await remote.getMovieCredits(movieId);
      final remoteReviewsResponse = await remote.getMovieReviews(
        movieId,
      ); // Get the full response model

      await local.putMovieDetails(remoteDetails);
      await local.putMovieCast(movieId, remoteCredits);
      await local.putMovieReviews(
        movieId,
        remoteReviewsResponse,
      ); // Store the full response model

      return remoteDetails.toEntity(
        casts: remoteCredits.toCastList(),
        reviews: remoteReviewsResponse.toReviewList(), // Extract results here
      );
    } catch (e) {
      _logger.d('Error getting movie details for $movieId: $e');
      final localDetails = await local.getMovieDetails(movieId);
      final localCredits = await local.getMovieCast(movieId);
      final localReviewsResponse = await local.getMovieReviews(movieId);

      if (localDetails != null ||
          localCredits != null ||
          localReviewsResponse != null) {
        _logger.d(
          'Serving partial movie details from stale local cache due to error.',
        );
        return MovieDetails(
          id: localDetails?.id ?? movieId,
          title: localDetails?.title ?? 'Unknown Title',
          overview: localDetails?.overview,
          posterPath: localDetails?.posterPath,
          backdropPath: localDetails?.backdropPath,
          releaseDate: localDetails?.releaseDate,
          voteAverage: localDetails?.voteAverage,
          genres: localDetails?.genres.map((e) => e.toEntity()).toList() ?? [],
          casts: localCredits?.toCastList() ?? [],
          reviews:
              localReviewsResponse?.toReviewList() ??
              [], // Extract results here
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<Cast>> getMovieCast(int movieId) async {
    try {
      final localCredits = await local.getMovieCast(movieId);
      if (localCredits != null) {
        print('Serving movie cast for $movieId from local cache.');
        return localCredits.toCastList();
      }

      print('Fetching movie cast for $movieId from remote.');
      final remoteCredits = await remote.getMovieCredits(movieId);
      await local.putMovieCast(movieId, remoteCredits);
      return remoteCredits.toCastList();
    } catch (e) {
      print('Error getting movie cast for $movieId: $e');
      rethrow;
    }
  }

  @override
  Future<List<Review>> getMovieReviews(int movieId) async {
    try {
      final localReviewsResponse = await local.getMovieReviews(movieId);
      if (localReviewsResponse != null) {
        print('Serving movie reviews for $movieId from local cache.');
        return localReviewsResponse.toReviewList(); // Extract results here
      }

      print('Fetching movie reviews for $movieId from remote.');
      final remoteReviewsResponse = await remote.getMovieReviews(movieId);
      await local.putMovieReviews(
        movieId,
        remoteReviewsResponse,
      ); // Store the full response
      return remoteReviewsResponse.toReviewList(); // Extract results here
    } catch (e) {
      print('Error getting movie reviews for $movieId: $e');
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getBookmarkedMovies() async {
    try {
      final bookmarkedModels = await local.getBookmarkedMovies();
      return bookmarkedModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      print('Error getting bookmarked movies: $e');
      rethrow;
    }
  }

  @override
  Future<void> addBookmark(Movie movie) async {
    try {
      await local.addBookmark(movie.toModel());
    } catch (e) {
      print('Error adding bookmark for ${movie.id}: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeBookmark(int movieId) async {
    try {
      await local.removeBookmark(movieId);
    } catch (e) {
      print('Error removing bookmark for $movieId: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isMovieBookmarked(int movieId) async {
    try {
      return await local.isMovieBookmarked(movieId);
    } catch (e) {
      print('Error checking bookmark for $movieId: $e');
      rethrow;
    }
  }
}
