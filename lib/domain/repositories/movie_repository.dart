import 'package:trelpix/domain/entities/cast.dart';
import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/domain/entities/review.dart';
import 'package:trelpix/domain/enums/movie_category.dart';

abstract class IMovieRepository {
  Future<List<Movie>> getMovies(MovieCategory category);
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<MovieDetails> getMovieDetails(int movieId);
  Future<List<Cast>> getMovieCast(int movieId);
  Future<List<Review>> getMovieReviews(int movieId);
  Future<List<Movie>> getBookmarkedMovies();
  Future<void> addBookmark(Movie movie);
  Future<void> removeBookmark(int movieId);
  Future<bool> isMovieBookmarked(int movieId);
}
