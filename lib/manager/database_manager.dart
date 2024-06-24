import 'package:hive_flutter/hive_flutter.dart';

String likedMovie = 'likedMovieBox';

class DatabaseManager {
  late Box _likedMovieBox;

  static final DatabaseManager _instance = DatabaseManager._();
  factory DatabaseManager() => _instance;
  DatabaseManager._();

  Future<void> init() async {
    await Hive.initFlutter();
    _likedMovieBox = await Hive.openBox(likedMovie);
  }

  Future<void> toggleLikeMovie(String id) async {
    if (isLikedMovie(id)) {
      await _unlikeMovie(id);
    } else {
      await _likeMovie(id);
    }
  }

  Future<void> _likeMovie(String movieId) async {
    await _likedMovieBox.put(movieId, true);
  }

  Future<void> _unlikeMovie(String movieId) async {
    await _likedMovieBox.delete(movieId);
  }

  bool isLikedMovie(String movieId) {
    return _likedMovieBox.containsKey(movieId);
  }

  List<String> getLikedMovies() {
    return _likedMovieBox.keys.cast<String>().toList();
  }

  Future<void> clearLikedMovies() async {
    await _likedMovieBox.clear();
  }
}
