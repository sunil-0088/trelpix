import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/presentation/pages/movie_detail_page.dart';
import 'package:trelpix/presentation/widgets/cached_image_widget.dart';
import 'package:trelpix/presentation/widgets/movie_card.dart';
import 'package:trelpix/presentation/widgets/section_title.dart';
import 'package:trelpix/presentation/widgets/shimmer/shimmer_movie_card_list.dart';
import 'package:trelpix/presentation/widgets/top_rated_carousel.dart';
import 'package:trelpix/providers/ui_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      physics:
          Platform.isIOS
              ? const BouncingScrollPhysics()
              : const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Stack(
            children: [
              TopRatedCarousel(screenHeight: screenHeight),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Scaffold.maybeOf(context)?.openDrawer();
                        },
                        child: Icon(
                          Platform.isIOS
                              ? CupertinoIcons.line_horizontal_3
                              : Icons.menu,
                          color: Colors.white70,
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        child: ClipOval(
                          child: CachedImageView(
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            placeholder: Image.asset('assets/person.png'),
                            imageUrl: "https://avatar.iran.liara.run/public",
                            errorWidget: Image.asset('assets/person.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SectionTitle(title: "Trending Movies"),
          _buildMovieList(context, ref, isTrending: true),

          SectionTitle(title: "Now Playing Movies"),
          _buildMovieList(context, ref, isTrending: false),
        ],
      ),
    );
  }

  Widget _buildMovieList(
    BuildContext context,
    WidgetRef ref, {
    required bool isTrending,
  }) {
    final moviesAsync =
        isTrending
            ? ref.watch(trendingMoviesProvider)
            : ref.watch(nowPlayingMoviesProvider);

    return moviesAsync.when(
      data: (movies) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(
                movie: movies[index],
                onTap: () {
                  Navigator.push(
                    context,
                    Platform.isIOS
                        ? CupertinoPageRoute(
                          builder:
                              (context) =>
                                  MovieDetailPage(movieId: movies[index].id),
                        )
                        : MaterialPageRoute(
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
      loading: () => const ShimmerMovieCardList(),
      error: (err, stack) {
        if (err is DeferredLoadException) {
          return const ShimmerMovieCardList();
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading movies.\nPlease check your internet connection and restart the app.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.yellowAccent),
              ),
            ),
          );
        }
      },
    );
  }
}
