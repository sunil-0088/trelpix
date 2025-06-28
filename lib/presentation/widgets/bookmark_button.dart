import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/presentation/providers/movie_providers.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({super.key, required this.movieDetails});
  final MovieDetails movieDetails;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarkedAsync = ref.watch(isBookmarkedProvider(movieDetails.id));
    final bookmarkedNotifier = ref.watch(bookmarkedMoviesProvider.notifier);
    return isBookmarkedAsync.when(
      loading: () => CircularProgressIndicator(color: Colors.white),
      error:
          (err, st) => ElevatedButton(
            onPressed: () {},
            child: const Icon(Icons.bookmark_border, color: Colors.red),
          ),
      data: (isBookmarked) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
            backgroundColor: Colors.white30, // Button background color
          ),

          onPressed: () {
            if (isBookmarked) {
              bookmarkedNotifier.removeBookmark(movieDetails.id);
            } else {
              bookmarkedNotifier.addBookmark(movieDetails);
            }
            // Optional: Show a snackbar message
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
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? Colors.amber : Colors.white,
          ),
        );
      },
    );
  }
}
