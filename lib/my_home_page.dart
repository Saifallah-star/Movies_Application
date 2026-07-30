import 'package:flutter/material.dart';
import 'package:flutter_application_api/presentation/screens/movies_screen.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return const MoviesScreen();
  }
}
