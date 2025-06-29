import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/presentation/pages/movie_detail_page.dart';
import 'package:trelpix/presentation/widgets/shimmer/shimmer_carousel_placeholder.dart';
import 'package:trelpix/providers/navigation_provider.dart';
import 'package:trelpix/providers/ui_providers.dart';

class TopRatedCarousel extends ConsumerWidget {
  const TopRatedCarousel({super.key, required this.screenHeight});

  final double screenHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topRatedMoviesAsync = ref.watch(topRatedMoviesProvider);

    return topRatedMoviesAsync.when(
      data: (movies) => _buildCarousel(movies, screenHeight, ref),
      loading: () => ShimmerCarouselPlaceholder(height: screenHeight * 0.6),
      error: (err, stack) {
        if (err is DeferredLoadException) {
          return ShimmerCarouselPlaceholder(height: screenHeight * 0.6);
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

  Widget _buildCarousel(
    List<Movie> movies,
    double screenHeight,
    WidgetRef ref,
  ) {
    final CarouselSliderController controller = CarouselSliderController();
    return SizedBox(
      height: screenHeight * 0.6,
      child: CarouselSlider.builder(
        carouselController: controller,
        itemCount: 5,
        itemBuilder: (context, index, _) {
          final movie = movies[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black45, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),

                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.fill,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MovieDetailPage(movieId: movie.id),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "Details",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        options: CarouselOptions(
          autoPlay: true,
          height: screenHeight * 0.6,
          enlargeCenterPage: true,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            ref.read(CarouselIndexProvider.notifier).state = index;
          },
          // aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}
