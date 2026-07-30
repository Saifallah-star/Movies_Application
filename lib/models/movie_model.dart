class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final double popularity;
  final List<int> genreIds;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.popularity,
    required this.genreIds,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Untitled',
      overview: json['overview'] ?? 'No overview available.',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? 'N/A',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'popularity': popularity,
      'genre_ids': genreIds,
    };
  }

  String get releaseYear {
    if (releaseDate.isNotEmpty && releaseDate.contains('-')) {
      return releaseDate.split('-')[0];
    }
    return releaseDate;
  }
}

class MovieResponseModel {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  MovieResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) {
    return MovieResponseModel(
      page: json['page'] ?? 1,
      results: json['results'] != null
          ? (json['results'] as List)
              .map((movieJson) => MovieModel.fromJson(movieJson))
              .toList()
          : [],
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
