import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/presentation/widgets/cast_card.dart';
import 'package:trelpix/presentation/widgets/section_title.dart';

class MovieCastSection extends ConsumerWidget {
  const MovieCastSection({super.key, required this.movie});

  final MovieDetails movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final casts = movie.casts;

    if (casts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Casts"),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: casts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cast = casts[index];
              return CastCard(cast: cast);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
