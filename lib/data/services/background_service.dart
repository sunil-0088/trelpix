import 'dart:async';
import 'package:logger/logger.dart';
import 'package:trelpix/data/datasources/local/movie_local_datasource.dart';
import 'package:trelpix/data/datasources/remote/movie_remote_datasource.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/services/image_cache_service.dart';
import 'package:trelpix/domain/enums/movie_category.dart';

class BackgroundService {
  final ImageCacheService imageCacheService;
  final MovieLocalDataSource local;
  final MovieRemoteDataSource remote;
  final _logger = Logger();

  BackgroundService({
    required this.local,
    required this.remote,
    required this.imageCacheService,
  });

  void start() {
    Future.microtask(() async {
      _logger.d('🔄 Starting background service...');

      // clearAllLocalMovieData()
      //     .then((_) => _logger.d('✅ Cleared all local movie data.'))
      //     .catchError((e) => _logger.e('❌ Error clearing local data: $e'));

      _logger.d('🔄 Background service started. Preloading movies...');
      await Future.wait([
        getMovies(MovieCategory.trending),
        getMovies(MovieCategory.nowPlaying),
        getMovies(MovieCategory.topRated),
      ]);
      _logger.d('✅ Background service completed preloading movies.');
    });
  }

  Future<void> getMovies(MovieCategory category) async {
    try {
      late List<MovieModel> remoteMovies;

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

      await local.putMovies(category, remoteMovies);

      await Future.wait(remoteMovies.map((movie) => getMovieDetails(movie.id)));
    } catch (e) {
      _logger.e('❌ Error fetching ${category.name} movies: $e');
    }
  }

  Future<void> getMovieDetails(int movieId) async {
    try {
      _logger.d('📥 Fetching full movie details for $movieId from remote.');

      final remoteDetails = await remote.getMovieDetails(movieId);
      await local.putMovieDetails(remoteDetails);

      await Future.wait([
        preloadImage(remoteDetails.posterPath),
        preloadImage(remoteDetails.backdropPath),
      ]);

      _logger.d('🎬 Movie details saved for $movieId: ${remoteDetails.title}');

      await _fetchAndStoreCast(movieId);
      await _fetchAndStoreReviews(movieId);
    } catch (e) {
      _logger.e('❌ Error fetching movie details for $movieId: $e');
    }
  }

  Future<void> _fetchAndStoreCast(int movieId) async {
    try {
      _logger.d('👥 Fetching cast for $movieId from remote.');
      final remoteCredits = await remote.getMovieCredits(movieId);
      await local.putMovieCast(movieId, remoteCredits);

      await Future.wait(
        remoteCredits.cast
            .where((c) => c.profilePath != null)
            .map((c) => preloadImage(c.profilePath!)),
      );

      _logger.d(
        '👥 Cast saved for $movieId: ${remoteCredits.cast.length} members',
      );
    } catch (e) {
      _logger.e('❌ Error fetching cast for $movieId: $e');
    }
  }

  Future<void> _fetchAndStoreReviews(int movieId) async {
    try {
      _logger.d('🗣️ Fetching reviews for $movieId from remote.');
      final remoteReviewsResponse = await remote.getMovieReviews(movieId);
      await local.putMovieReviews(movieId, remoteReviewsResponse);

      await Future.wait(
        remoteReviewsResponse.results
            .where((r) => r.authorDetails?.avatarPath != null)
            .map((r) => preloadImage(r.authorDetails!.avatarPath!)),
      );

      _logger.d(
        '📝 Reviews saved for $movieId: ${remoteReviewsResponse.results.length}',
      );
    } catch (e) {
      _logger.e('❌ Error fetching reviews for $movieId: $e');
    }
  }

  Future<void> preloadImage(String? imagePath) async {
    try {
      if (imagePath == null || imagePath.trim().isEmpty) return;

      final fullUrl = getImageFullUrl(imagePath);
      _logger.d('🖼️ Preloading image: $fullUrl');
      await imageCacheService.downloadAndCacheImage(fullUrl);
    } catch (e) {
      _logger.e('❌ Error preloading image: $e');
    }
  }

  String getImageFullUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('/https')) {
      return path.substring(1); // remove slash for gravatar URLs
    }
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  Future<void> clearAllLocalMovieData() async {
    await Future.wait([
      local.trendingBox.clear(),
      local.nowPlayingBox.clear(),
      local.topRatedBox.clear(),
      local.detailsBox.clear(),
      local.creditsBox.clear(),
      local.reviewsBox.clear(),
    ]);
  }
}
