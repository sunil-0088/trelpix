import 'dart:io';

abstract class ICachedImageRepository {
  Future<void> preloadImage(String imageUrl);
  Future<File?> getCachedImageFile(String imageUrl);
  Future<void> clearImageCache();
}
