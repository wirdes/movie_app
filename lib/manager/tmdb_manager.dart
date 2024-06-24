import 'package:movie_app/.env/env.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MvManager {
  final tmdb = TMDB(
    ApiKeys(apiKEY, apiTOKEN),
    logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true),
  );

  Future<Map<dynamic, dynamic>> getPopularMovies({int page = 1}) async {
    return tmdb.v3.movies.getPopular(page: page);
  }

  Future<Map<dynamic, dynamic>> getMovieDetails(int movieId) async {
    return tmdb.v3.movies.getDetails(movieId);
  }

  Future<Map<dynamic, dynamic>> getTrending() async {
    return tmdb.v3.trending.getTrending();
  }

  Future<Map<dynamic, dynamic>> getDiscoverMovies() async {
    return tmdb.v3.discover.getMovies();
  }

  Future<Map<dynamic, dynamic>> getTopRatedMovies() async {
    return tmdb.v3.tv.getTopRated();
  }
}
