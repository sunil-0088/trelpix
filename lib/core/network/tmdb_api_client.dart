import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';

part 'tmdb_api_client.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TmdbApiClient {
  factory TmdbApiClient(Dio dio, {String baseUrl}) = _TmdbApiClient;

  @GET("trending/movie/day")
  Future<MoviesResponse> getTrendingMovies(@Query("api_key") String apiKey);

  @GET("movie/now_playing")
  Future<MoviesResponse> getNowPlayingMovies(@Query("api_key") String apiKey);

  @GET("movie/top_rated?language=en-US&page=1")
  Future<MoviesResponse> getTopRatedMovies(@Query("api_key") String apiKey);

  @GET("search/movie")
  Future<MoviesResponse> searchMovies(
    @Query("api_key") String apiKey,
    @Query("query") String query,
    @Query("page") int page,
  );

  @GET("movie/{movie_id}")
  Future<MovieDetailsModel> getMovieDetails(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );

  @GET("movie/{movie_id}/credits")
  Future<CreditsResponseModel> getMovieCredits(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );

  @GET("movie/{movie_id}/reviews")
  Future<ReviewsResponseModel> getMovieReviews(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );
}
