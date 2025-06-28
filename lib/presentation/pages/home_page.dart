import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/presentation/pages/movie_detail_page.dart';
import 'package:trelpix/presentation/pages/search_page.dart';
import 'package:trelpix/presentation/providers/movie_providers.dart';
import 'package:trelpix/presentation/widgets/movie_card.dart';
import 'package:trelpix/presentation/widgets/section_title.dart';
import 'package:trelpix/presentation/widgets/top_rated_carousel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingMoviesAsync = ref.watch(trendingMoviesProvider);
    final nowPlayingMoviesAsync = ref.watch(nowPlayingMoviesProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Hi, ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Inshorts!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://avatar.iran.liara.run/public",
                    ),
                    radius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white30),
                      const SizedBox(width: 20),
                      Text(
                        "Search",
                        style: TextStyle(fontSize: 18, color: Colors.white30),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            TopRatedCarousel(screenHeight: screenHeight),

            SectionTitle(title: "Tending Movies"),
            _buildMovieList(context, trendingMoviesAsync, ref),

            SectionTitle(title: "Now Playing Movies"),
            _buildMovieList(context, nowPlayingMoviesAsync, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(
    BuildContext context,
    AsyncValue moviesAsync,
    WidgetRef ref,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    return moviesAsync.when(
      data: (movies) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          height: screenHeight * .3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(
                movie: movies[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MovieDetailPage(movieId: movies[index].id),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (err, stack) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: $err',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Colors.redAccent),
            ),
          ),
    );
  }
}
