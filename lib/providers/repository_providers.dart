import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trelpix/data/repositories/movie_repository_impl.dart';
import 'package:trelpix/data/repositories/image_repository_impl.dart';

import 'package:trelpix/domain/repositories/movie_repository.dart';
import 'package:trelpix/domain/repositories/cached_image_repositoy.dart';

import 'package:trelpix/providers/core_providers.dart';
import 'package:trelpix/providers/datasource_providers.dart';

final movieRepositoryProvider = Provider<IMovieRepository>((ref) {
  final remoteDataSource = ref.watch(movieRemoteDataSourceProvider);
  final localDataSourceAsync = ref.watch(movieLocalDataSourceProvider);
  final imageCacheService = ref.watch(imageCacheServiceProvider);

  return localDataSourceAsync.when(
    data:
        (localDataSource) => MovieRepositoryImpl(
          remote: remoteDataSource,
          local: localDataSource,
          imageCacheService: imageCacheService,
        ),
    loading:
        () =>
            throw DeferredLoadException(
              'Local data source is still loading. Please wait...',
            ),
    error:
        (err, st) => throw Exception('Failed to load local data source: $err'),
  );
});

final imageRepositoryProvider = Provider<ICachedImageRepository>((ref) {
  final imageCacheService = ref.watch(imageCacheServiceProvider);
  return ImageRepositoryImpl(imageCacheService: imageCacheService);
});
