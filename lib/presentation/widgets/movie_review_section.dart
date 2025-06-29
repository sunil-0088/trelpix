import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/presentation/widgets/review_card.dart';
import 'package:trelpix/presentation/widgets/section_title.dart';

class MovieReviewSection extends ConsumerWidget {
  const MovieReviewSection({super.key, required this.movie});

  final MovieDetails movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = movie.reviews;

    if (reviews.isEmpty) {
      return const SizedBox.shrink();
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
  }
}
