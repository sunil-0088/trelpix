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

  @override
  List<Object?> get props => [
    ...super.props,
    genres,
    casts, // Include in props
    reviews, // Include in props
  ];
}
