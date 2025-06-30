import 'package:trelpix/domain/repositories/movie_repository.dart';

class IsMovieBookmarked {
  final IMovieRepository repository;
  IsMovieBookmarked(this.repository);
  Future<bool> call(int movieId) => repository.isMovieBookmarked(movieId);
}
