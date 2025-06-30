import 'package:trelpix/domain/entities/cast.dart';
import 'package:trelpix/domain/repositories/movie_repository.dart';

class GetMovieCast {
  final IMovieRepository repository;
  GetMovieCast(this.repository);
  Future<List<Cast>> call(int movieId) => repository.getMovieCast(movieId);
}
