import 'package:trelpix/domain/repositories/cached_image_repositoy.dart';

class PreloadImage {
  final ICachedImageRepository repository;
  PreloadImage(this.repository);
  Future<void> call(String imageUrl) => repository.preloadImage(imageUrl);
}
