import 'dart:async';
import 'dart:io';

import 'package:cache_systems/cache_systems.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';

class MovieBackground extends StatefulWidget {
  final List<Movie> movies;
  const MovieBackground({super.key, required this.movies});

  @override
  State<MovieBackground> createState() => _MovieBackgroundState();
}

class _MovieBackgroundState extends State<MovieBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  final ScrollController scrollController3 = ScrollController();
  final ScrollController scrollController4 = ScrollController();
  int get length => widget.movies.length ~/ 4;
  List<Movie> get rightMovies => widget.movies.take(length).toList();
  List<Movie> get leftMovies => widget.movies.skip(length).take(length).toList();
  List<Movie> get rightMovies2 => widget.movies.skip(length * 2).take(length).toList();
  List<Movie> get leftMovies2 => widget.movies.skip(length * 3).take(length).toList();

  double top = -2000;
  double left = -500;
  double shake(double animation) => 5 * animation * (1 - animation);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _controller.repeat();
    _controller.addListener(() {
      final value = shake(_controller.value) * 300;
      if (scrollController.hasClients) {
        scrollController.jumpTo(value);
        scrollController2.jumpTo(value);
        scrollController3.jumpTo(value);
        scrollController4.jumpTo(value);
      }

      if (scrollController.offset >= scrollController.position.maxScrollExtent) {
        _controller.stop();
      }
    });

    print("rightMovies: ${rightMovies.length} leftMovies: ${leftMovies.length}rightMovies2: ${rightMovies2.length} leftMovies2: ${leftMovies2.length} ");
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();
    scrollController2.dispose();
    scrollController3.dispose();
    scrollController4.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: GestureDetector(
      onPanUpdate: (details) {
        _controller.stop();
        var topPos = top + (details.delta.dy * 1.5);
        var leftPos = left + (details.delta.dx * 1.5);
        if (topPos > 0 || leftPos > 36 || leftPos < -925 || topPos < -3700) {
          return;
        }

        setState(() {
          top = topPos;
          left = leftPos;
        });
      },
      onPanEnd: (details) {
        _controller.repeat();
      },
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              top: top,
              left: left,
              child: Row(
                children: [
                  MovieBackgroundWidget(size: size, controller: _controller, scrollController: scrollController, movies: rightMovies),
                  MovieBackgroundWidget(size: size, controller: _controller, scrollController: scrollController2, movies: leftMovies, reverse: true),
                  MovieBackgroundWidget(size: size, controller: _controller, scrollController: scrollController3, movies: rightMovies2),
                  MovieBackgroundWidget(size: size, controller: _controller, scrollController: scrollController4, movies: leftMovies2, reverse: true),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class MovieBackgroundWidget extends StatelessWidget {
  final Size size;
  final AnimationController controller;
  final ScrollController scrollController;
  final List<Movie> movies;
  final bool? reverse;
  const MovieBackgroundWidget({
    super.key,
    required this.size,
    required this.controller,
    required this.scrollController,
    required this.movies,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 5,
      width: size.width * .8,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return ListView(
              reverse: reverse!,
              controller: scrollController,
              physics: const NeverScrollableScrollPhysics(),
              children: movies.map((movie) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      controller.stop();
                      await Navigator.of(context).pushNamed('/movie-details', arguments: movie.id);
                      controller.forward();
                    },
                    child: Container(
                        width: 200,
                        height: size.height * .4,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 0.2),
                        ),
                        child: MovieImage(movie: movie)),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}

class MovieImage extends StatefulWidget {
  final Movie movie;
  const MovieImage({super.key, required this.movie});

  @override
  State<MovieImage> createState() => _MovieImageState();
}

class _MovieImageState extends State<MovieImage> {
  ImageProvider? imageProvider;
  Timer? timer;

  void _loadImage() async {
    final image = await CacheSystem().getFile(Uri.parse("https://image.tmdb.org/t/p/w500${widget.movie.imageUrl}"));
    if (image == null) {
      timer = Timer(const Duration(seconds: 3), () {
        _loadImage();
      });
      return;
    }
    timer?.cancel();

    setState(() {
      imageProvider = FileImage(File(image.path));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    if (imageProvider == null) {
      return const Center(child: SizedBox(width: 68, height: 68, child: CircularProgressIndicator()));
    } else {
      return Hero(tag: widget.movie.id, child: Image(image: imageProvider!, fit: BoxFit.cover));
    }
  }
}
