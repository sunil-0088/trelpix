import 'package:flutter/material.dart';
import 'package:trelpix/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.onTap});
  final Movie movie;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 170,
                  width: 150,
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black45, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  // margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image:
                          movie.fullPosterUrl != null
                              ? NetworkImage(movie.fullPosterUrl!)
                              : AssetImage('assets/images/placeholder.png')
                                  as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Row(
                    children: [
                      Text(
                        movie.voteAverage!.toStringAsFixed(1),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.star, size: 15, color: Colors.yellow),
                    ],
                  ),
                ),
                // Positioned(

                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Expanded(
                //         child:
                //       ),
                //       const SizedBox(width: 20),

                //     ],
                //   ),
                // ),
              ],
            ),
            Container(
              width: 150,
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  if (movie.releaseDate != null)
                    Text(
                      "2023",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
