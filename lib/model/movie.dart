import 'package:flutter/cupertino.dart';
import 'package:movie_app/manager/tmdb_manager.dart';

class Movie with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String releaseDate;
  bool isFavorite;

  Movie({required this.id, required this.title, required this.imageUrl, required this.description, required this.releaseDate, this.isFavorite = false});
  Future<void> toggleFavorite(Movie movie) async {}
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'releaseDate': releaseDate,
      'isFavorite': isFavorite,
    };
  }

  Movie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        releaseDate = json['releaseDate'],
        isFavorite = json['isFavorite'];

  bool fav(Movie mov) => mov.isFavorite;

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, imageUrl: $imageUrl, description: $description, releaseDate: $releaseDate, isFavorite: $isFavorite}';
  }
}

class Movies with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _discoverMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _tvPopular = [];
  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get discoverMovies => _discoverMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get tvPopular => _tvPopular;
  List<Movie> get movies => _movies;

  Movie findSingleById(String id) => _movies.firstWhere((movie) => movie.id == id);

  Future<void> loadMovies() async {
    List<Movie> loadedTrendingMovies = [];
    List<Movie> loadedDiscoverMovies = [];
    List<Movie> loadedtopRatedMovies = [];
    List<Movie> loadedTvPopular = [];

    try {
      final trending = await MvManager().getTrending();
      final discover = await MvManager().getDiscoverMovies();
      final topRated = await MvManager().getTopRatedMovies();
      final popular = await MvManager().getPopularMovies();
      final trendingReults = trending['results'] as List<dynamic>;
      final discoverResults = discover['results'] as List<dynamic>;
      final topRatedResults = topRated['results'] as List<dynamic>;
      final tvPopularResults = popular['results'] as List<dynamic>;

      for (var movieData in trendingReults) {
        if (loadedTrendingMovies.where((element) => element.id == movieData['id'].toString()).isEmpty) {
          loadedTrendingMovies.add(Movie(
            id: movieData['id'].toString(),
            title: movieData['original_title'] ?? 'Loading...',
            description: movieData['overview'] ?? 'Loading...',
            releaseDate: movieData['release_date'] ?? 'Loading...',
            imageUrl: movieData['poster_path'] ?? 'Loading...',
          ));
        }
      }
      for (var movieData in discoverResults) {
        if (loadedDiscoverMovies.where((element) => element.id == movieData['id'].toString()).isEmpty) {
          loadedDiscoverMovies.add(Movie(
            id: movieData['id'].toString(),
            title: movieData['original_title'] ?? 'Loading...',
            description: movieData['overview'] ?? 'Loading...',
            releaseDate: movieData['release_date'] ?? 'Loading...',
            imageUrl: movieData['poster_path'] ?? 'Loading...',
          ));
        }
      }
      for (var movieData in topRatedResults) {
        if (loadedtopRatedMovies.where((element) => element.id == movieData['id'].toString()).isEmpty) {
          loadedtopRatedMovies.add(Movie(
            id: movieData['id'].toString(),
            title: movieData['original_title'] ?? 'Loading...',
            description: movieData['overview'] ?? 'Loading...',
            releaseDate: movieData['release_date'] ?? 'Loading...',
            imageUrl: movieData['poster_path'] ?? 'Loading...',
          ));
        }
      }
      for (var movieData in tvPopularResults) {
        if (loadedTvPopular.where((element) => element.id == movieData['id'].toString()).isEmpty) {
          loadedTvPopular.add(Movie(
            id: movieData['id'].toString(),
            title: movieData['original_title'] ?? 'Loading...',
            description: movieData['overview'] ?? 'Loading...',
            releaseDate: movieData['release_date'] ?? 'Loading...',
            imageUrl: movieData['poster_path'] ?? 'Loading...',
          ));
        }
      }
      _trendingMovies = loadedTrendingMovies;
      _discoverMovies = loadedDiscoverMovies;
      _topRatedMovies = loadedtopRatedMovies;
      _tvPopular = loadedTvPopular;
      _movies = [];
      _movies.addAll(_trendingMovies);
      for (var element in _discoverMovies) {
        if (_movies.where((movie) => movie.id == element.id).isEmpty) {
          _movies.add(element);
        }
      }
      for (var element in _topRatedMovies) {
        if (_movies.where((movie) => movie.id == element.id).isEmpty) {
          _movies.add(element);
        }
      }
      for (var element in _tvPopular) {
        if (_movies.where((movie) => movie.id == element.id).isEmpty) {
          _movies.add(element);
        }
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
