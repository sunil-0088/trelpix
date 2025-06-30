import 'package:trelpix/data/models/author_details_model.dart';
import 'package:trelpix/data/models/cast_model.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/genre_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/review_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';
import 'package:trelpix/domain/entities/author_details.dart';
import 'package:trelpix/domain/entities/cast.dart';
import 'package:trelpix/domain/entities/genre.dart';
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/domain/entities/review.dart';

extension AuthorDetailsModelToEntity on AuthorDetailsModel {
  AuthorDetails toEntity() {
    return AuthorDetails(
      name: name,
      username: username,
      avatarPath: avatarPath,
      rating: rating,
    );
  }
}

extension AuthorDetailsEntityToModel on AuthorDetails {
  AuthorDetailsModel toModel() {
    return AuthorDetailsModel(
      name: name,
      username: username,
      avatarPath: avatarPath,
      rating: rating,
    );
  }
}

extension CastModelToEntity on CastModel {
  Cast toEntity() {
    return Cast(
      id: id,
      name: name,
      character: character,
      profilePath: profilePath,
    );
  }
}

extension CastEntityToModel on Cast {
  CastModel toModel() {
    return CastModel(
      id: id,
      name: name,
      character: character,
      profilePath: profilePath,
    );
  }
}

extension GenreModelToEntity on GenreModel {
  Genre toEntity() {
    return Genre(id: id, name: name);
  }
}

extension GenreEntityToModel on Genre {
  GenreModel toModel() {
    return GenreModel(id: id, name: name);
  }
}

extension MovieModelToEntity on MovieModel {
  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      overview: overview,
    );
  }
}

extension MovieEntityToModel on Movie {
  MovieModel toModel() {
    return MovieModel(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      overview: overview,
    );
  }
}

extension ReviewModelToEntity on ReviewModel {
  Review toEntity() {
    return Review(
      id: id,
      author: author,
      content: content,
      url: url,
      authorDetails: authorDetails?.toEntity(),
      updatedAt: updatedAt,
    );
  }
}

extension ReviewEntityToModel on Review {
  ReviewModel toModel() {
    return ReviewModel(
      id: id,
      author: author,
      content: content,
      url: url,
      authorDetails: authorDetails?.toModel(),
      updatedAt: updatedAt,
    );
  }
}

extension MovieDetailsModelToEntity on MovieDetailsModel {
  MovieDetails toEntity({List<Cast>? casts, List<Review>? reviews}) {
    return MovieDetails(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      genres: genres.map((g) => g.toEntity()).toList(),

      casts: casts ?? const [],
      reviews: reviews ?? const [],
    );
  }
}

extension MovieDetailsEntityToModel on MovieDetails {
  MovieDetailsModel toModel() {
    return MovieDetailsModel(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      genres: genres.map((g) => g.toModel()).toList(),
      casts: const [],
      reviews: const [],
    );
  }
}

extension CreditsResponseModelToCastList on CreditsResponseModel {
  List<Cast> toCastList() {
    return cast.map((castModel) => castModel.toEntity()).toList();
  }
}

extension ReviewsResponseModelToReviewList on ReviewsResponseModel {
  List<Review> toReviewList() {
    return results.map((reviewModel) => reviewModel.toEntity()).toList();
  }
}
