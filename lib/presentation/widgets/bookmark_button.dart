import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/providers/ui_providers.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({super.key, required this.movieDetails});

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarkedAsync = ref.watch(isBookmarkedProvider(movieDetails.id));
    final bookmarkedNotifier = ref.watch(bookmarkedMoviesProvider.notifier);

    return isBookmarkedAsync.when(
      loading:
          () =>
              Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(color: Colors.white),
      error:
          (err, st) =>
              Platform.isIOS
                  ? CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    color: CupertinoColors.systemRed,
                    child: const Icon(CupertinoIcons.bookmark),
                    onPressed: () {},
                  )
                  : ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.red.withValues(alpha: .8),
                    ),
                    child: const Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                    ),
                  ),
      data: (isBookmarked) {
        final icon =
            isBookmarked
                ? (Platform.isIOS
                    ? CupertinoIcons.bookmark_fill
                    : Icons.bookmark)
                : (Platform.isIOS
                    ? CupertinoIcons.bookmark
                    : Icons.bookmark_border);

        final iconColor = isBookmarked ? Colors.amber : Colors.white;

        return Platform.isIOS
            ? CupertinoButton(
              padding: const EdgeInsets.all(10),
              color: Colors.black.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(40),
              child: Icon(icon, color: iconColor),
              onPressed: () {
                if (isBookmarked) {
                  bookmarkedNotifier.removeBookmark(movieDetails.id);
                } else {
                  bookmarkedNotifier.addBookmark(movieDetails);
                }
                // Optional: Add Cupertino-style feedback
                showCupertinoDialog(
                  context: context,
                  builder:
                      (_) => CupertinoAlertDialog(
                        title: Text(
                          isBookmarked
                              ? 'Removed from bookmarks'
                              : 'Added to bookmarks',
                        ),
                        actions: [
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: const Text("OK"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                );
              },
            )
            : ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
                backgroundColor: Colors.white30,
              ),
              onPressed: () {
                if (isBookmarked) {
                  bookmarkedNotifier.removeBookmark(movieDetails.id);
                } else {
                  bookmarkedNotifier.addBookmark(movieDetails);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBookmarked
                          ? 'Removed from bookmarks'
                          : 'Added to bookmarks',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Icon(icon, color: iconColor),
            );
      },
    );
  }
}
