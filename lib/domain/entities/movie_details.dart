import 'package:trelpix/domain/entities/cast.dart';
import 'package:trelpix/domain/entities/genre.dart';
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/entities/review.dart';

class MovieDetails extends Movie {
  final List<Genre> genres;
  final List<Cast> casts; // New field
  final List<Review> reviews; // New field

  const MovieDetails({
    required super.id,
    required super.title,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    super.voteAverage,
    super.overview,
    this.genres = const [], // Default to empty list
    this.casts = const [], // Default to empty list
    this.reviews = const [], // Default to empty list
  });
  MovieDetails copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    int? voteCount,
    String? releaseDate,
    int? runtime,
    List<Genre>? genres,
    List<Cast>? casts,
    List<Review>? reviews,
  }) {
    return MovieDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      casts: casts ?? this.casts,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    genres,
    casts, // Include in props
    reviews, // Include in props
  ];
}
