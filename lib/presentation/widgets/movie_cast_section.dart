import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/presentation/providers/movie_providers.dart';
import 'package:trelpix/presentation/widgets/cast_card.dart';
import 'package:trelpix/presentation/widgets/section_title.dart';

class MovieCastSection extends ConsumerWidget {
  const MovieCastSection({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
    // final movieCastAsync = ref.watch(getMovieCastUseCaseProvider(movieId));
    //   return movieCastAsync.when(
    //     loading: () => const Center(child: CircularProgressIndicator()),
    //     error:
    //         (err, stack) => Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text(
    //             'Error loading cast: $err',
    //             style: Theme.of(
    //               context,
    //             ).textTheme.bodyMedium!.copyWith(color: Colors.redAccent),
    //           ),
    //         ),
    //     data: (casts) {
    //       if (casts.isEmpty) {
    //         return const SizedBox.shrink(); // Hide if no cast
    //       }
    //       return Container(
    //         // margin: const EdgeInsets.symmetric(horizontal: 20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SectionTitle(title: "Casts"),
    //             Container(
    //               margin: EdgeInsets.symmetric(horizontal: 16),
    //               height: 180,
    //               child: ListView.builder(
    //                 scrollDirection: Axis.horizontal,
    //                 itemCount: casts.length,
    //                 itemBuilder: (context, index) {
    //                   final cast = casts[index];
    //                   // if (cast.fullProfileUrl == null ||
    //                   //     cast.fullProfileUrl!.isEmpty) {
    //                   //   return const SizedBox.shrink(); // Skip empty profiles
    //                   // }
    //                   return CastCard(cast: cast);
    //                 },
    //               ),
    //             ),
    //             const SizedBox(height: 16),
    //           ],
    //         ),
    //       );
    //     },
    //   );
  }
}
