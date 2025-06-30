import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/providers/usecase_providers.dart';

class CachedImageView extends ConsumerStatefulWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImageView({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.placeholder,
    this.errorWidget,
  });

  @override
  ConsumerState<CachedImageView> createState() => _CachedImageViewState();
}

class _CachedImageViewState extends ConsumerState<CachedImageView> {
  late Future<File?> _cachedImageFileFuture;

  @override
  void initState() {
    super.initState();
    _cachedImageFileFuture = _getCachedImageFile();
  }

  Future<File?> _getCachedImageFile() async {
    final getImageFile = ref.read(getImageFileUseCaseProvider);
    return await getImageFile(widget.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child:
            widget.errorWidget ??
            const Center(child: Icon(Icons.broken_image, size: 48)),
      );
    }

    return FutureBuilder<File?>(
      future: _cachedImageFileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(
              snapshot.data!,
              fit: widget.fit,
              height: widget.height,
              width: widget.width,
              errorBuilder: (context, error, stackTrace) {
                return _buildNetworkImage();
              },
            );
          } else {
            return _buildNetworkImage();
          }
        }
        return SizedBox(
          height: widget.height,
          width: widget.width,
          child:
              widget.placeholder ??
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildNetworkImage() {
    return Image.network(
      widget.imageUrl,
      fit: widget.fit,
      height: widget.height,
      width: widget.width,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: widget.height,
          width: widget.width,
          child: Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          height: widget.height,
          width: widget.width,
          child:
              widget.errorWidget ??
              const Center(child: Icon(Icons.broken_image, size: 48)),
        );
      },
    );
  }
}

class UseCaseProviders {
  final Provider<dynamic> getImageFileUseCaseProvider;

  UseCaseProviders._(this.getImageFileUseCaseProvider);

  static final getImageFile = Provider(
    (ref) =>
        throw UnimplementedError(
          'getImageFileUseCaseProvider is not yet implemented in UseCaseProviders class.',
        ),
  );
}
