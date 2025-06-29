// lib/domain/usecases/image/get_image_file.dart
import 'dart:io';
import 'package:trelpix/domain/repositories/cached_image_repositoy.dart';

class GetImageFile {
  final ICachedImageRepository repository;
  GetImageFile(this.repository);
  Future<File?> call(String imageUrl) =>
      repository.getCachedImageFile(imageUrl);
}
