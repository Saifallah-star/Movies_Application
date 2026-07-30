import 'package:flutter_application_api/API/api_service.dart';
import 'package:flutter_application_api/models/movie_model.dart';
import 'package:flutter_application_api/repositories/movie_repository.dart';

/// Concrete implementation of MovieRepository
class MovieRepositoryImpl implements MovieRepository {
  final ApiService _apiService;

  MovieRepositoryImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<List<MovieModel>> getMovies(String endpoint) async {
    final response = await _apiService.fetchMovies(endpoint);
    return response.results;
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await _apiService.searchMovies(query);
    return response.results;
  }
}
