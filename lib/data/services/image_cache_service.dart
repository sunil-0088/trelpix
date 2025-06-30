// lib/data/services/image_cache_service.dart
// ... (Paste the updated ImageCacheService code from the previous response here) ...
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ImageCacheService {
  final Dio dio;

  ImageCacheService(this.dio);

  Future<String> _getCacheDirectoryPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${dir.path}/trelpix_image_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir.path;
  }

  String _getLocalFilePath(String cacheDirPath, String imageUrl) {
    final fileName = '${imageUrl.hashCode}.jpg';
    return '$cacheDirPath/$fileName';
  }

  Future<File?> downloadAndCacheImage(String imageUrl) async {
    if (imageUrl.isEmpty) return null;

    final cacheDirPath = await _getCacheDirectoryPath();
    final filePath = _getLocalFilePath(cacheDirPath, imageUrl);
    final file = File(filePath);

    if (await file.exists()) {
      return file;
    }

    try {
      await dio.download(imageUrl, filePath);
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<File?> getCachedImageFile(String imageUrl) async {
    if (imageUrl.isEmpty) return null;

    final cacheDirPath = await _getCacheDirectoryPath();
    final filePath = _getLocalFilePath(cacheDirPath, imageUrl);
    final file = File(filePath);

    if (await file.exists()) {
      return file;
    } else {
      return null;
    }
  }

  Future<void> clearCache() async {
    final cacheDirPath = await _getCacheDirectoryPath();
    final directory = Directory(cacheDirPath);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }
}
