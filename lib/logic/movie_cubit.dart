import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_api/API/api_constants.dart';
import 'package:flutter_application_api/logic/movie_state.dart';
import 'package:flutter_application_api/repositories/movie_repository.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _movieRepository;
  String _currentCategory = 'Now Playing';

  MovieCubit(this._movieRepository) : super(const MovieInitialState());

  String get currentCategory => _currentCategory;

  Future<void> fetchMovies({String? endpoint, String? categoryName}) async {
    final String targetEndpoint = endpoint ?? Constants.nowPlayingEndpoint;
    if (categoryName != null) {
      _currentCategory = categoryName;
    }

    emit(const MovieLoadingState());
    try {
      final movies = await _movieRepository.getMovies(targetEndpoint);
      if (movies.isEmpty) {
        emit(const MovieErrorState('No movies found for this category.'));
      } else {
        emit(
          MovieLoadedState(movies: movies, activeCategory: _currentCategory),
        );
      }
    } catch (e) {
      emit(MovieErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      fetchMovies(
        endpoint: Constants.nowPlayingEndpoint,
        categoryName: 'Now Playing',
      );
      return;
    }

    _currentCategory = 'Search Results';
    emit(const MovieLoadingState());
    try {
      final movies = await _movieRepository.searchMovies(query);
      if (movies.isEmpty) {
        emit(MovieErrorState('No movies found matching "$query"'));
      } else {
        emit(
          MovieLoadedState(movies: movies, activeCategory: _currentCategory),
        );
      }
    } catch (e) {
      emit(MovieErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
