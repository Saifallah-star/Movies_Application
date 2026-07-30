import 'package:dio/dio.dart';
import 'package:flutter_application_api/API/api_constants.dart';
import 'package:flutter_application_api/models/movie_model.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: Constants.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  Future<MovieResponseModel> fetchMovies(String categoryEndpoint) async {
    try {
      final String url = '${Constants.movieURL}$categoryEndpoint';
      final response = await _dio.get(
        url,
        queryParameters: {
          'api_key': Constants.apiKey,
          'language': 'en-US',
          'page': 1,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return MovieResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load movies. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<MovieResponseModel> searchMovies(String query) async {
    try {
      final String url = '${Constants.baseUrl}${Constants.searchEndpoint}';
      final response = await _dio.get(
        url,
        queryParameters: {
          'api_key': Constants.apiKey,
          'query': query,
          'language': 'en-US',
          'page': 1,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return MovieResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to search movies. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server returned error ${error.response?.statusCode}: ${error.response?.statusMessage}';
      case DioExceptionType.connectionError:
        return 'No internet connection available.';
      default:
        return 'Network error: ${error.message}';
    }
  }
}
