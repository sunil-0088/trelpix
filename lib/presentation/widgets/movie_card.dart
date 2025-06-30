import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/presentation/widgets/cached_image_widget.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final placeholderIcon = Platform.isIOS ? CupertinoIcons.film : Icons.movie;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 170,
                    width: 150,
                    foregroundDecoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black45, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    color: Colors.grey.shade900,
                    child:
                        movie.fullPosterUrl == null ||
                                movie.fullPosterUrl!.isEmpty
                            ? Center(
                              child: Icon(
                                placeholderIcon,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                            : CachedImageView(
                              imageUrl: movie.fullPosterUrl!,
                              fit: BoxFit.cover,
                              placeholder: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                  ),
                ),
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Row(
                    children: [
                      Text(
                        movie.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
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
              ],
            ),
            Container(
              width: 150,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movie.releaseDate?.split('-').first ?? 'Unknown',
                    maxLines: 1,
                    style: const TextStyle(
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
