import 'dart:io';
import 'dart:ui';

import 'package:cache_systems/cache_systems.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:movie_app/components/pop_button.dart';
import 'package:movie_app/manager/database_manager.dart';
import 'package:movie_app/manager/tmdb_manager.dart';
import 'package:movie_app/model/movie.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  void getDetails() async {
    print("Getting details");
    final movie = widget.movie;
    final details = await MvManager().getMovieDetails(int.parse(movie.id));
    print(details);
    // movie.setTitle(details['title']);
    // movie.setDescription(details['description']);
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: CacheSystem().getFile(Uri.parse("https://image.tmdb.org/t/p/original${movie.imageUrl}")),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Hero(
                  tag: movie.id,
                  child: Image.file(
                    height: size.height,
                    File(snapshot.data!.path),
                    fit: BoxFit.cover,
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const Positioned(
            top: 48,
            left: 24,
            child: SizedBox(
              width: 64,
              height: 64,
              child: PopButton(),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 24,
            right: 24,
            child: Container(
              height: size.height * .4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        movie.title,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        movie.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 48,
            right: 24,
            child: SizedBox(
              width: 64,
              height: 64,
              child: PopButton(
                child: LikeButton(
                  isLiked: DatabaseManager().isLikedMovie(movie.id),
                  onTap: (isLiked) async {
                    HapticFeedback.heavyImpact();
                    await DatabaseManager().toggleLikeMovie(movie.id);
                    return !isLiked;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
