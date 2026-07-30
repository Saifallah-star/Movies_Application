import 'package:flutter/material.dart';
import 'package:flutter_application_api/my_app.dart';
import 'package:flutter_application_api/repositories/movie_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final movieRepository = MovieRepositoryImpl();

  runApp(MyApp(movieRepository: movieRepository));
}
