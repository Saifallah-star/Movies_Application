import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_api/API/api_constants.dart';
import 'package:flutter_application_api/logic/movie_cubit.dart';
import 'package:flutter_application_api/logic/movie_state.dart';
import 'package:flutter_application_api/presentation/widgets/category_selector.dart';
import 'package:flutter_application_api/presentation/widgets/loading_shimmer.dart';
import 'package:flutter_application_api/presentation/widgets/movie_banner.dart';
import 'package:flutter_application_api/presentation/widgets/movie_card.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initial fetch for Now Playing movies
    context.read<MovieCubit>().fetchMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.local_movies_rounded,
                color: Colors.black,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'CinePulse',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
            onPressed: () {
              _searchController.clear();
              context.read<MovieCubit>().fetchMovies();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFFF59E0B),
        backgroundColor: const Color(0xFF1E293B),
        onRefresh: () async {
          _searchController.clear();
          await context.read<MovieCubit>().fetchMovies();
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (query) {
                    context.read<MovieCubit>().searchMovies(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search movies by title...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFFF59E0B),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              context.read<MovieCubit>().fetchMovies();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFF59E0B),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<MovieCubit, MovieState>(
                builder: (context, state) {
                  final activeCategory = context
                      .watch<MovieCubit>()
                      .currentCategory;

                  return CategorySelector(
                    activeCategory: activeCategory,
                    onCategorySelected: (endpoint, name) {
                      _searchController.clear();
                      context.read<MovieCubit>().fetchMovies(
                        endpoint: endpoint,
                        categoryName: name,
                      );
                    },
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            BlocBuilder<MovieCubit, MovieState>(
              builder: (context, state) {
                if (state is MovieLoadingState || state is MovieInitialState) {
                  return const SliverToBoxAdapter(child: LoadingShimmer());
                } else if (state is MovieErrorState) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFEF4444),
                              size: 56,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<MovieCubit>().fetchMovies();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF59E0B),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text(
                                'Retry',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is MovieLoadedState) {
                  return SliverMainAxisGroup(
                    slivers: [
                      if (state.movies.isNotEmpty)
                        SliverToBoxAdapter(
                          child: MovieBanner(movies: state.movies),
                        ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.activeCategory,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${state.movies.length} movies',
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return MovieCard(movie: state.movies[index]);
                          }, childCount: state.movies.length),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 30)),
                    ],
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
