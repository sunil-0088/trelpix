import 'dart:io';
import 'package:flutter/cupertino.dart';
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

    final listView = ListView.builder(
      padding: const EdgeInsets.only(left: 16),
      scrollDirection: Axis.horizontal,
      itemCount: reviews.length,
      physics:
          Platform.isIOS
              ? const BouncingScrollPhysics()
              : const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return ReviewCard(review: reviews[index]);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Reviews"),
        SizedBox(
          height: 180,
          child:
              Platform.isIOS
                  ? CupertinoScrollbar(child: listView)
                  : Scrollbar(child: listView),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
