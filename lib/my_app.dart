import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_api/logic/movie_cubit.dart';
import 'package:flutter_application_api/presentation/screens/movies_screen.dart';
import 'package:flutter_application_api/repositories/movie_repository.dart';
import 'package:flutter_application_api/repositories/movie_repository_impl.dart';

class MyApp extends StatelessWidget {
  final MovieRepository movieRepository;

  const MyApp({
    super.key,
    required this.movieRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieCubit(movieRepository),
      child: MaterialApp(
        title: 'CinePulse - Movie Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFF59E0B),
            surface: Color(0xFF1E293B),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F172A),
            elevation: 0,
          ),
        ),
        home: const MoviesScreen(),
      ),
    );
  }
}
