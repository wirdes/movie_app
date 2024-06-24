import 'package:hive_flutter/hive_flutter.dart';

String likedMovie = 'likedMovieBox';

class DatabaseManager {
  late Box likedMovieBox;

  static final DatabaseManager _instance = DatabaseManager._();
  factory DatabaseManager() => _instance;
  DatabaseManager._();

  Future<void> init() async {
    await Hive.initFlutter();
    likedMovieBox = await Hive.openBox(likedMovie);
  }

  Future<void> addLikedMovie(String movieId) async {
    await likedMovieBox.put(movieId, true);
  }

  Future<void> removeLikedMovie(String movieId) async {
    await likedMovieBox.delete(movieId);
  }

  bool isLikedMovie(String movieId) {
    return likedMovieBox.containsKey(movieId);
  }

  List<String> getLikedMovies() {
    return likedMovieBox.keys.cast<String>().toList();
  }

  Future<void> clearLikedMovies() async {
    await likedMovieBox.clear();
  }
}
