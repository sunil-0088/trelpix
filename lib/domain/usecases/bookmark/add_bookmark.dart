import 'package:trelpix/domain/entities/movie.dart';
import 'package:trelpix/domain/repositories/movie_repository.dart';

class AddBookmark {
  final IMovieRepository repository;
  AddBookmark(this.repository);
  Future<void> call(Movie movie) => repository.addBookmark(movie);
}
