import 'package:flutter/material.dart';
import 'package:movie_app/components/custom_button.dart';
import 'package:movie_app/components/movie_background.dart';
import 'package:movie_app/model/movie.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Movies(),
        ),
      ],
      child: Consumer<Movies>(
        builder: (context, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cinema',
          theme: ThemeData(brightness: Brightness.dark),
          routes: {
            //  '/movie-details': (ctx) => MovieDetailsScreen(),
            '/': (ctx) => const HomeScreen(),
            '/home': (ctx) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: Provider.of<Movies>(context, listen: false).loadMovies(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('An error occurred! + ${snapshot.error.toString()}'),
                );
              } else {
                return Consumer<Movies>(
                  builder: (ctx, movieData, _) => SizedBox.fromSize(
                      size: size,
                      child: Stack(
                        children: [
                          MovieBackground(movies: movieData.trendingMovies),
                          const CustomButton(),
                        ],
                      )),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
