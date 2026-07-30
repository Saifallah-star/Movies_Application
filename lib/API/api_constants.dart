import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String movieURL = 'https://api.themoviedb.org/3/movie';
  static const String nowPlayingEndpoint = '/now_playing';
  static const String popularEndpoint = '/popular';
  static const String topRatedEndpoint = '/top_rated';
  static const String upcomingEndpoint = '/upcoming';
  static const String searchEndpoint = '/search/movie';

  /// Dynamically fetch API Key from .env or --dart-define
  static String get apiKey {
    return dotenv.env['TMDB_API_KEY'] ??
        const String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
  }


  // TMDB Image Base URLs
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String originalImageBaseUrl = 'https://image.tmdb.org/t/p/original';

  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    return '$imageBaseUrl$path';
  }

  static String getOriginalImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    return '$originalImageBaseUrl$path';
  }
}
