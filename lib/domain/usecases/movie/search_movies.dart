import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/repositories/movie_repository.dart';

class SearchMovies {
  final IMovieRepository repository;
  SearchMovies(this.repository);
  Future<List<Movie>> call(String query, {int page = 1}) =>
      repository.searchMovies(query, page: page);
}
