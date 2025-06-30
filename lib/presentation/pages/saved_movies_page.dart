import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/presentation/pages/movie_detail_page.dart';
import 'package:trelpix/presentation/widgets/movie_card.dart';
import 'package:trelpix/providers/ui_providers.dart';

class SavedMoviesPage extends ConsumerWidget {
  const SavedMoviesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedMoviesAsync = ref.watch(bookmarkedMoviesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Movies',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: bookmarkedMoviesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading saved movies: $err',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: Colors.redAccent),
                ),
              ),
            ),
        data: (movies) {
          if (movies.isEmpty) {
            return Center(
              child: Text(
                'No saved movies yet. Bookmark some from the Home or Search tab!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movieId: movie.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
