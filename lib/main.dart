import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_api/my_app.dart';
import 'package:flutter_application_api/repositories/movie_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Note: Could not load .env file: $e");
  }

  final movieRepository = MovieRepositoryImpl();

  runApp(MyApp(movieRepository: movieRepository));
}

