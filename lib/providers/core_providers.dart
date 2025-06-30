import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:trelpix/core/network/tmdb_api_client.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';
import 'package:trelpix/data/services/background_service.dart';
import 'package:trelpix/data/services/image_cache_service.dart';
import 'package:trelpix/providers/datasource_providers.dart';

final dioProvider = Provider<Dio>(
  (ref) => Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      headers: {
        'Authorization':
            'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTA5NDFkYjZmZDgxM2UzOGQzMmU4OGRiMDBmNGJkZCIsIm5iZiI6MTc1MTAxODU3OC4zNjQsInN1YiI6IjY4NWU2YzUyMjBhMTk4YzExZDE1NWIxZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.BjBbp8BNpHhCjz0wCjSJYMycqUtk5PfomuwORXZQIpA',
        'Accept': 'application/json',
      },
    ),
  ),
);

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

final backgroundServiceProvider = Provider<AsyncValue<BackgroundService>>((
  ref,
) {
  final imageCacheService = ref.watch(imageCacheServiceProvider);
  final movieRemoteDataSource = ref.watch(movieRemoteDataSourceProvider);
  final movieLocalDataSourceAsync = ref.watch(movieLocalDataSourceProvider);

  return movieLocalDataSourceAsync.when(
    data: (localDataSource) {
      return AsyncValue.data(
        BackgroundService(
          local: localDataSource,
          remote: movieRemoteDataSource,
          imageCacheService: imageCacheService,
        ),
      );
    },

    loading: () => const AsyncValue.loading(),
    error: (err, st) => AsyncValue.error(err, st),
  );
});
