import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;
  final String? overview;

  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.overview,
  });

  // Helper method to get full image URL
  String? get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;
  String? get fullBackdropUrl =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/w500$backdropPath'
          : null;

  // Added toJson for consistency, though MovieModel handles the actual serialization
  // for network/Hive. This is primarily for debugging or if a generic Movie needs to be
  // converted to JSON outside of a MovieModel context.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'overview': overview,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    posterPath,
    backdropPath,
    releaseDate,
    voteAverage,
    overview,
  ];
}
