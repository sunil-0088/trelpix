import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/presentation/pages/movie_detail_page.dart';
import 'package:trelpix/presentation/pages/search_page.dart';
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
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       RichText(
          //         text: TextSpan(
          //           text: 'Hi, ',
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 34,
          //             fontWeight: FontWeight.bold,
          //           ),
          //           children: [
          //             TextSpan(
          //               text: 'Inshorts!',
          //               style: TextStyle(
          //                 color: Theme.of(context).colorScheme.primary,
          //                 fontSize: 34,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       CircleAvatar(
          //         backgroundImage: NetworkImage(
          //           "https://avatar.iran.liara.run/public",
          //         ),
          //         radius: 20,
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 20),

          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SearchPage()),
          //     );
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 20),
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(20),
          //         color: Theme.of(
          //           context,
          //         ).colorScheme.primary.withValues(alpha: 0.3),
          //       ),
          //       child: Row(
          //         children: [
          //           Icon(Icons.search, color: Colors.white30),
          //           const SizedBox(width: 20),
          //           Text(
          //             "Search",
          //             style: TextStyle(fontSize: 18, color: Colors.white30),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 20),
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
                      Icon(Icons.menu, color: Colors.white70),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://avatar.iran.liara.run/public",
                        ),
                        radius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SectionTitle(title: "Tending Movies"),
          _buildMovieList(context, ref, true),

          SectionTitle(title: "Now Playing Movies"),
          _buildMovieList(context, ref, false),
        ],
      ),
    );
  }

  Widget _buildMovieList(BuildContext context, WidgetRef ref, bool isTrending) {
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
      loading: () => ShimmerMovieCardList(),
      error: (err, stack) {
        if (err is DeferredLoadException) {
          return ShimmerMovieCardList();
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading movies: $err',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.redAccent),
              ),
            ),
          );
        }
      },
    );
  }
}
