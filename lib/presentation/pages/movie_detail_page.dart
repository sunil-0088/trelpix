import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/presentation/widgets/bookmark_button.dart';
import 'package:trelpix/presentation/widgets/cached_image_widget.dart';
import 'package:trelpix/presentation/widgets/movie_cast_section.dart';
import 'package:trelpix/presentation/widgets/movie_info_section.dart';
import 'package:trelpix/presentation/widgets/movie_review_section.dart';
import 'package:trelpix/providers/ui_providers.dart';
import 'package:trelpix/utils/colors.dart';

class MovieDetailPage extends ConsumerWidget {
  final int movieId;
  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailsAsync = ref.watch(movieDetailsProvider(movieId));
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final content = movieDetailsAsync.when(
      loading:
          () => Center(
            child:
                Platform.isIOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
          ),
      error:
          (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading movie details: $err',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.redAccent),
              ),
            ),
          ),
      data: (movieDetails) {
        if (movieDetails == null) {
          return Center(
            child: Text(
              'Movie details not found.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: height * 0.3,
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kBackgroundColor, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child:
                        movieDetails.fullBackdropUrl == null ||
                                movieDetails.fullBackdropUrl!.isEmpty
                            ? const Center(
                              child: Icon(
                                Icons.movie,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                            : CachedImageView(
                              imageUrl: movieDetails.fullBackdropUrl!,
                              fit: BoxFit.cover,
                            ),
                  ),

                  MovieInfoSection(movieDetails: movieDetails),
                  MovieCastSection(movie: movieDetails),
                  MovieReviewSection(movie: movieDetails),

                  const SizedBox(height: 24),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Platform.isIOS
                        ? CupertinoButton(
                          padding: const EdgeInsets.all(12),
                          color: Colors.black.withValues(alpha: .3),
                          borderRadius: BorderRadius.circular(50),
                          onPressed: () => Navigator.pop(context),
                          child: const Icon(
                            CupertinoIcons.back,
                            color: Colors.white,
                          ),
                        )
                        : ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                            backgroundColor: Colors.white30,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                    BookmarkButton(movieDetails: movieDetails),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: content)
        : Scaffold(body: content);
  }
}
