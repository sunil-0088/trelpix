import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/presentation/providers/movie_providers.dart';
import 'package:trelpix/presentation/widgets/review_card.dart';
import 'package:trelpix/presentation/widgets/section_title.dart';

class MovieReviewSection extends ConsumerWidget {
  const MovieReviewSection({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();

    /*final movieReviewsAsync = ref.watch(movieReviewsProvider(movieId));

    return movieReviewsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (err, stack) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error loading cast: $err',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Colors.redAccent),
            ),
          ),
      data: (reviews) {
        if (reviews.isEmpty) {
          return const SizedBox.shrink(); // Hide if no cast
        }
        return Container(
          // margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: "Reviews"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ReviewCard(review: review);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );*/
  }
}
