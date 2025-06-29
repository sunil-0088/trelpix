// lib/providers/datasource_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core network/data layer imports
import 'package:trelpix/data/datasources/local/movie_local_datasource.dart';
import 'package:trelpix/data/datasources/remote/movie_remote_datasource.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';

// Import core providers for dependencies
import 'package:trelpix/providers/core_providers.dart';

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
