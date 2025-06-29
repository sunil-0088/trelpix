import 'package:hive/hive.dart';
import 'package:trelpix/data/models/cast_model.dart';
import 'package:trelpix/data/models/genre_model.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/review_model.dart';

part 'movie_details_model.g.dart';

@HiveType(typeId: 2)
class MovieDetailsModel extends MovieModel {
  @HiveField(
    7,
  ) // Start new HiveField IDs after the parent's highest field ID (which is 6 for overview)
  final List<GenreModel> genres;
  @HiveField(8)
  final List<CastModel> casts;
  @HiveField(9)
  final List<ReviewModel> reviews;
  @HiveField(10) // Additional fields common in MovieDetails
  final int? runtime;
  @HiveField(11)
  final String? tagline;
  @HiveField(12)
  final String? homepage;
  @HiveField(13)
  final String? status;

  const MovieDetailsModel({
    required super.id,
    required super.title,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    super.voteAverage,
    super.overview,
    this.genres = const [],
    this.casts = const [],
    this.reviews = const [],
    this.runtime,
    this.tagline,
    this.homepage,
    this.status,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      overview: json['overview'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      // Casts and Reviews are typically separate API calls in TMDB,
      // so they might not be directly in the MovieDetails JSON.
      // If your API aggregates them, adjust this.
      // For now, initialize as empty, and they will be populated from separate API calls
      // and then combined in the repository if you decide to load them together.
      casts: const [],
      reviews: const [],
      runtime: json['runtime'] as int?,
      tagline: json['tagline'] as String?,
      homepage: json['homepage'] as String?,
      status: json['status'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    genres,
    casts,
    reviews,
    runtime,
    tagline,
    homepage,
    status,
  ];
}
