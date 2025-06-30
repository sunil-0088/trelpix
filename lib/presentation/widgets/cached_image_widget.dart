import 'dart:io';
import 'package:flutter/cupertino.dart';
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
      return _buildErrorWidget();
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
          child: widget.placeholder ?? _defaultLoadingIndicator(),
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
            child:
                Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child:
          widget.errorWidget ??
          const Center(child: Icon(Icons.broken_image, size: 48)),
    );
  }

  Widget _defaultLoadingIndicator() {
    return Center(
      child:
          Platform.isIOS
              ? const CupertinoActivityIndicator()
              : const CircularProgressIndicator(),
    );
  }
}
