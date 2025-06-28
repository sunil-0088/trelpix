import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final String fileName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    required this.fileName,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
      future: ImageCacheService.getImageProvider(imageUrl, fileName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final image = Image(
            image: snapshot.data!,
            width: width,
            height: height,
            fit: fit,
          );

          return borderRadius != null
              ? ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.zero,
                child: image,
              )
              : image;
        } else if (snapshot.hasError) {
          return errorWidget ??
              const Center(child: Icon(Icons.broken_image, color: Colors.grey));
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: width ?? double.infinity,
              height: height ?? double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: borderRadius ?? BorderRadius.zero,
              ),
            ),
          );
        }
      },
    );
  }
}
