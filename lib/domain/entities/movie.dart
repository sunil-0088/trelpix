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

  String? get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;
  String? get fullBackdropUrl =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/w500$backdropPath'
          : null;

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
