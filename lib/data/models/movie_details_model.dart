import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trelpix/data/models/cast_model.dart';
import 'package:trelpix/data/models/genre_model.dart';
import 'package:trelpix/data/models/review_model.dart';
import 'package:trelpix/domain/entities/movie_details.dart';

part 'movie_details_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable(fieldRename: FieldRename.snake)
class MovieDetailsModel extends MovieDetails {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @override
  @HiveField(3)
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @override
  @HiveField(4)
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @override
  @HiveField(5)
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @override
  @HiveField(6)
  @JsonKey(name: 'overview')
  final String? overview;

  @override
  @HiveField(7)
  final List<GenreModel> genres;
  @override
  @HiveField(8) // New HiveField for casts
  final List<CastModel> casts;
  @override
  @HiveField(9) // New HiveField for reviews
  final List<ReviewModel> reviews;

  const MovieDetailsModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.overview,
    this.genres = const [],
    this.casts = const [],
    this.reviews = const [],
  }) : super(
         id: id,
         title: title,
         posterPath: posterPath,
         backdropPath: backdropPath,
         releaseDate: releaseDate,
         voteAverage: voteAverage,
         overview: overview,
         genres: genres,
         casts: casts,
         reviews: reviews,
       );

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieDetailsModelToJson(this);

  factory MovieDetailsModel.fromEntity(MovieDetails movieDetails) {
    return MovieDetailsModel(
      id: movieDetails.id,
      title: movieDetails.title,
      posterPath: movieDetails.posterPath,
      backdropPath: movieDetails.backdropPath,
      releaseDate: movieDetails.releaseDate,
      voteAverage: movieDetails.voteAverage,
      overview: movieDetails.overview,
      genres: movieDetails.genres.map((g) => GenreModel.fromEntity(g)).toList(),
      casts: movieDetails.casts.map((c) => CastModel.fromEntity(c)).toList(),
      reviews:
          movieDetails.reviews.map((r) => ReviewModel.fromEntity(r)).toList(),
    );
  }
}
