import 'dart:async';
import 'dart:io';
import 'package:trelpix/data/services/image_cache_service.dart';
import 'package:trelpix/domain/repositories/cached_image_repositoy.dart';

class ImageRepositoryImpl implements ICachedImageRepository {
  final ImageCacheService imageCacheService;

  ImageRepositoryImpl({required this.imageCacheService});

  @override
  Future<void> preloadImage(String imageUrl) async {
    unawaited(imageCacheService.downloadAndCacheImage(imageUrl));
  }

  @override
  Future<File?> getCachedImageFile(String imageUrl) {
    return imageCacheService.getCachedImageFile(imageUrl);
  }

  @override
  Future<void> clearImageCache() {
    return imageCacheService.clearCache();
  }
}
