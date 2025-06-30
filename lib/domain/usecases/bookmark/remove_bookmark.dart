import 'package:trelpix/domain/repositories/movie_repository.dart';

class RemoveBookmark {
  final IMovieRepository repository;
  RemoveBookmark(this.repository);
  Future<void> call(int movieId) => repository.removeBookmark(movieId);
}
