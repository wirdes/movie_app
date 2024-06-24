import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Movie Details Screen'),
            Hero(
              tag: movie.id,
              child: Image.network(
                height: size.height,
                "https://image.tmdb.org/t/p/original${movie.imageUrl}",
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
