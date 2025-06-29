import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/enums/movie_category.dart';
import 'package:trelpix/domain/repositories/movie_repository.dart';

class GetMovies {
  final IMovieRepository repository;
  GetMovies(this.repository);
  Future<List<Movie>> call(MovieCategory category) =>
      repository.getMovies(category);
}
