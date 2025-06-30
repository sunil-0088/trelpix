import 'package:trelpix/domain/entities/movie_details.dart';
import 'package:trelpix/domain/repositories/movie_repository.dart';

class GetMovieDetails {
  final IMovieRepository repository;
  GetMovieDetails(this.repository);
  Future<MovieDetails> call(int movieId) => repository.getMovieDetails(movieId);
}
