// lib/providers/repository_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data layer imports
import 'package:trelpix/data/repositories/movie_repository_impl.dart';
import 'package:trelpix/data/repositories/image_repository_impl.dart';

// Domain layer imports (interfaces)
import 'package:trelpix/domain/repositories/movie_repository.dart';
import 'package:trelpix/domain/repositories/cached_image_repositoy.dart'; // Note: typo 'repositoy' -> 'repository'

// Import data source and core providers for dependencies
import 'package:trelpix/providers/core_providers.dart';
import 'package:trelpix/providers/datasource_providers.dart';

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
