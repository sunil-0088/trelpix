import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/domain/entities/movie.dart'; // Import Hive

part 'movie_model.g.dart';

// TypeId must be unique for each HiveType within your app
@HiveType(typeId: 0)
// Maps JSON keys to Dart field names.
@JsonSerializable(fieldRename: FieldRename.snake)
class MovieModel extends Movie {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @HiveField(3)
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @HiveField(4)
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @HiveField(5)
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @HiveField(6)
  @JsonKey(name: 'overview')
  final String? overview;

  const MovieModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.overview,
  }) : super(
         id: id,
         title: title,
         posterPath: posterPath,
         backdropPath: backdropPath,
         releaseDate: releaseDate,
         voteAverage: voteAverage,
         overview: overview,
       );

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  @override // Override to use the class's own toJson method
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  // Helper to convert Movie entity back to MovieModel if needed for saving
  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
      overview: movie.overview,
    );
  }

  // Equatable properties are still inherited from Movie
}

@JsonSerializable()
class MoviesResponse {
  final int page;
  final List<MovieModel> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  MoviesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesResponseToJson(this);
}
