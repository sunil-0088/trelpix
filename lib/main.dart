import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trelpix/data/models/author_details_model.dart';
import 'package:trelpix/data/models/cast_model.dart';
import 'package:trelpix/data/models/credits_response_model.dart';
import 'package:trelpix/data/models/genre_model.dart';
import 'package:trelpix/data/models/movie_details_model.dart';
import 'package:trelpix/data/models/movie_model.dart';
import 'package:trelpix/data/models/review_model.dart';
import 'package:trelpix/data/models/reviews_response_model.dart';
import 'package:trelpix/presentation/pages/main_page.dart';

const String tmdbApiKey = '050941db6fd813e38d32e88db00f4bdd';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MovieModelAdapter());
  Hive.registerAdapter(GenreModelAdapter());
  Hive.registerAdapter(MovieDetailsModelAdapter());
  Hive.registerAdapter(CastModelAdapter());
  Hive.registerAdapter(ReviewModelAdapter());
  Hive.registerAdapter(AuthorDetailsModelAdapter());
  Hive.registerAdapter(CreditsResponseModelAdapter());
  Hive.registerAdapter(ReviewsResponseModelAdapter());

  runApp(ProviderScope(child: const MovieApp()));
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    final themeData = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color.fromRGBO(18, 16, 18, 1),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurple,
      ),
    );

    if (isIOS) {
      return CupertinoApp(
        title: 'Movie DB App',
        debugShowCheckedModeBanner: false,
        theme: const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: CupertinoColors.activeBlue,
          scaffoldBackgroundColor: CupertinoColors.black,
          textTheme: CupertinoTextThemeData(
            navLargeTitleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.white,
            ),
            textStyle: TextStyle(color: CupertinoColors.systemGrey),
          ),
        ),
        home: const MainPage(),
      );
    } else {
      return MaterialApp(
        title: 'Movie DB App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: themeData,
        home: const MainPage(),
      );
    }
  }
}
