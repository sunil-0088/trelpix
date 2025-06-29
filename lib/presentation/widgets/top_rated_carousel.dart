import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/presentation/pages/movie_detail_page.dart';
import 'package:trelpix/providers/navigation_provider.dart';
import 'package:trelpix/providers/ui_providers.dart';

class TopRatedCarousel extends ConsumerWidget {
  const TopRatedCarousel({super.key, required this.screenHeight});

  final double screenHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topRatedMoviesAsync = ref.watch(topRatedMoviesProvider);
    final carouselIndex = ref.watch(CarouselIndexProvider);

    return topRatedMoviesAsync.when(
      data:
          (movies) => _buildCarousel(movies, screenHeight, ref, carouselIndex),
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: $error',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Colors.redAccent),
            ),
          ),
    );
  }

  Widget _buildCarousel(
    List<Movie> movies,
    double screenHeight,
    WidgetRef ref,
    int carouselIndex,
  ) {
    final CarouselSliderController controller = CarouselSliderController();
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.5,
          child: CarouselSlider.builder(
            carouselController: controller,
            itemCount: 5,
            itemBuilder: (context, index, _) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailPage(movieId: movie.id),
                    ),
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),

                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          fit: BoxFit.fill,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              height: screenHeight * 0.45,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              onPageChanged: (index, reason) {
                ref.read(CarouselIndexProvider.notifier).state = index;
              },
              // aspectRatio: 16 / 9,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children:
                movies.asMap().entries.take(5).map((entry) {
                  return GestureDetector(
                    onTap: () => controller.animateToPage(entry.key),
                    child: Container(
                      width: 10.0,
                      height: 10.0,
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(
                          alpha: carouselIndex == entry.key ? 0.9 : 0.4,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
