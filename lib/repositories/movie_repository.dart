import 'package:flutter_application_api/models/movie_model.dart';

/// Abstract repository interface adhering to OOP principles (Dependency Inversion)
abstract class MovieRepository {
  Future<List<MovieModel>> getMovies(String endpoint);
  Future<List<MovieModel>> searchMovies(String query);
}
