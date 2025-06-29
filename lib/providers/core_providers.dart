// lib/providers/core_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core network/data layer imports
import 'package:trelpix/core/network/tmdb_api_client.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';
import 'package:trelpix/data/services/image_cache_service.dart';

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
