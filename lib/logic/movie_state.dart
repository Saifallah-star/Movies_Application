import 'package:flutter_application_api/models/movie_model.dart';

abstract class MovieState {
  // or i can use sealed class
  const MovieState();
}

class MovieInitialState extends MovieState {
  const MovieInitialState();
}

class MovieLoadingState extends MovieState {
  const MovieLoadingState();
}

class MovieLoadedState extends MovieState {
  final List<MovieModel> movies;
  final String activeCategory;

  const MovieLoadedState({required this.movies, required this.activeCategory});
}

class MovieErrorState extends MovieState {
  final String message;

  const MovieErrorState(this.message);
}
