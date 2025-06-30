import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_more_text/read_more_text.dart';
import 'package:trelpix/domain/entities/movie_details.dart';

class MovieInfoSection extends StatelessWidget {
  const MovieInfoSection({super.key, required this.movieDetails});
  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: movieDetails.title,
                      child: Text(
                        movieDetails.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movieDetails.releaseDate ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  Text(
                    movieDetails.voteAverage?.toStringAsFixed(1) ?? '0.0',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Platform.isIOS ? CupertinoIcons.star_fill : Icons.star,
                    size: 16,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (movieDetails.genres.isNotEmpty) ...[
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  movieDetails.genres
                      .map(
                        (genre) => Chip(
                          label: Text(
                            genre.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.white24,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Overview
          if (movieDetails.overview?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ReadMoreText(
                movieDetails.overview!,
                numLines: 3,
                readLessText: "Read less",
                readMoreText: "Read more",
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
