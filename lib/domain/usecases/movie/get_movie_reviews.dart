import 'package:trelpix/domain/entities/review.dart';
import 'package:trelpix/domain/repositories/movie_repository.dart';

class GetMovieReviews {
  final IMovieRepository repository;
  GetMovieReviews(this.repository);
  Future<List<Review>> call(int movieId) => repository.getMovieReviews(movieId);
}
