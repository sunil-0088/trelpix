import 'package:trelpix/core/network/tmdb_api_client.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';
import 'package:trelpix/data/models/movie_model.dart';

class MovieRemoteDataSource {
  final TmdbApiClient apiClient;
  final String apiKey = '050941db6fd813e38d32e88db00f4bdd';

  MovieRemoteDataSource(this.apiClient);

  Future<List<MovieModel>> getTrendingMovies() async {
    final responseMap = await apiClient.getTrendingMovies(apiKey);
    return responseMap.results;
  }

  Future<List<MovieModel>> getNowPlayingMovies() async {
    final responseMap = await apiClient.getNowPlayingMovies(apiKey);
    return responseMap.results;
  }

  Future<List<MovieModel>> getTopRatedMovies() async {
    final responseMap = await apiClient.getTopRatedMovies(apiKey);
    return responseMap.results;
  }

  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    final responseMap = await apiClient.searchMovies(apiKey, query, page);
    return responseMap.results;
  }

  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final responseMap = await apiClient.getMovieDetails(movieId, apiKey);
    return responseMap;
  }

  Future<CreditsResponseModel> getMovieCredits(int movieId) async {
    final responseMap = await apiClient.getMovieCredits(movieId, apiKey);
    return responseMap;
  }

  Future<ReviewsResponseModel> getMovieReviews(int movieId) async {
    final responseMap = await apiClient.getMovieReviews(movieId, apiKey);
    return responseMap;
  }
}
