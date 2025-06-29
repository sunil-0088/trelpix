import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/repositories/movie_repository.dart';

class GetBookmarkedMovies {
  final IMovieRepository repository;
  GetBookmarkedMovies(this.repository);
  Future<List<Movie>> call() => repository.getBookmarkedMovies();
}
