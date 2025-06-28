// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:inshorts_task/domain/entities/movie.dart';
// import 'package:inshorts_task/presentation/pages/movie_detail_page.dart';
// import 'package:inshorts_task/presentation/providers/movie_providers.dart';
// import 'package:inshorts_task/presentation/widgets/movies_h_card.dart';
// import 'package:inshorts_task/presentation/widgets/seach_delegate.dart';
// import 'package:inshorts_task/utils/colors.dart';

// class MovieList extends ConsumerWidget {
//   MovieList({super.key});
//   final PageController pageController = PageController(
//     initialPage: 0,
//     viewportFraction: 0.9,
//   );
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final trendingMoviesAsync = ref.watch(trendingMoviesProvider);
//     final screenHeight = MediaQuery.of(context).size.height;

//     final movies = trendingMoviesAsync.when(
//       data: (movies) => movies,
//       loading: () => null,
//       error: (error, stackTrace) => null,
//     );

//     return Scaffold(
//       body: Stack(
//         children: [
//           SafeArea(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 10,
//                       horizontal: 20,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Hi Sunil",
//                           style: TextStyle(color: Colors.white, fontSize: 34),
//                         ),
//                         CircleAvatar(),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   GestureDetector(
//                     onTap: () {
//                       showSearch(context: context, delegate: MovieSearchDelegate(ref));
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: kSearchbarColor,
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.search, color: Colors.white30),
//                             const SizedBox(width: 20),
//                             Text(
//                               "Search",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white30,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   TopRatedCarousel(screenHeight: screenHeight, movies: movies),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 30,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               "Trending Movies",
//                               style: TextStyle(
//                                 color: Colors.white54,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 20),

//                         Container(
//                           height: screenHeight*.28,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: movies!.length,
//                             itemBuilder: (context, index) {
//                                 return MoviesHCard(movie: movies[index]);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(child: Container()),
          
//         ],
//       ),
//     );
//   }
// }


