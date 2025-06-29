// lib/presentation/widgets/cached_image_view.dart (or wherever you prefer to put reusable widgets)

import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Ensure this import path correctly points to where getImageFileUseCaseProvider is defined/exposed.
// Based on your setup, it's likely in 'package:trelpix/providers/usecase_providers.dart'
// or a main 'package:trelpix/providers.dart' that re-exports it.
import 'package:trelpix/providers/usecase_providers.dart'; // Assuming it's here

class CachedImageView extends ConsumerStatefulWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Widget? placeholder; // Optional placeholder widget
  final Widget? errorWidget; // Optional error widget

  const CachedImageView({
    super.key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
    this.placeholder,
    this.errorWidget,
  });

  @override
  ConsumerState<CachedImageView> createState() => _CachedImageViewState();
}

class _CachedImageViewState extends ConsumerState<CachedImageView> {
  // We use a Future<File?> to hold the result of checking the local cache
  late Future<File?> _cachedImageFileFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future when the widget is first created
    _cachedImageFileFuture = _getCachedImageFile();
  }

  // Helper method to retrieve the cached image file
  Future<File?> _getCachedImageFile() async {
    // Get the GetImageFile use case from the appropriate provider
    // This assumes getImageFileUseCaseProvider is accessible here.
    final getImageFile = ref.read(getImageFileUseCaseProvider);
    // Call the use case to check for the cached file
    return await getImageFile(widget.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    // Handle cases where imageUrl is empty or invalid
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
            // Case 1: Image is found in the local cache, display using Image.file
            return Image.file(
              snapshot.data!, // The File object from the cache
              fit: widget.fit,
              height: widget.height,
              width: widget.width,
              errorBuilder: (context, error, stackTrace) {
                // If there's an error loading the local file, fall back to network
                return _buildNetworkImage();
              },
            );
          } else {
            // Case 2: Not found in cache (snapshot.data is null), fall back to network
            return _buildNetworkImage();
          }
        }
        // Case 3: Still checking the cache (loading state)
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

  // Helper method to build the Image.network widget
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
        // If network loading also fails
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

// Helper class to encapsulate use case providers for easier access.
// You might put this in a file like 'lib/providers/usecase_providers.dart'
// and then import it like `import 'package:trelpix/providers/usecase_providers.dart' as usecaseProviders;`
// in files that need to access them.
class UseCaseProviders {
  // Example:
  final Provider<dynamic>
  getImageFileUseCaseProvider; // Replace dynamic with actual type

  // You would initialize this with all your use case providers
  UseCaseProviders._(this.getImageFileUseCaseProvider);

  // This is a placeholder. You'd define your actual use case providers here.
  // For this example, we directly reference the one needed by CachedImageView.
  static final getImageFile = Provider(
    (ref) =>
        throw UnimplementedError(
          'getImageFileUseCaseProvider is not yet implemented in UseCaseProviders class.',
        ),
  );

  // In a real scenario, usecase_providers.dart would directly define
  // final getImageFileUseCaseProvider = Provider<GetImageFile>(...);
  // and you'd import it as `import 'package:trelpix/providers/usecase_providers.dart';`
  // and use `ref.read(getImageFileUseCaseProvider)`.
  //
  // For the purpose of this example, assuming getImageFileUseCaseProvider is correctly
  // defined in your `lib/providers/usecase_providers.dart` file.
  // The line `final getImageFile = ref.read(usecaseProviders.getImageFileUseCaseProvider);`
  // above implies that you might have put them inside a class/object.
  // A more common approach is just direct top-level providers like:
  // `final getImageFileUseCaseProvider = Provider<GetImageFile>(...);`
  // And then import `import 'package:trelpix/providers/usecase_providers.dart';`
  // and use `ref.read(getImageFileUseCaseProvider);`
}
