// lib/presentation/widgets/shimmer_movie_card_list.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerMovieCardList extends StatelessWidget {
  const ShimmerMovieCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder:
            (_, __) => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade700,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 180,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 150,
                      height: 12,
                      color: Colors.grey,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 80,
                      height: 10,
                      color: Colors.grey,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
