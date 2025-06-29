import 'package:flutter/foundation.dart';
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
import 'package:device_preview/device_preview.dart';

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

  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MovieApp(), // Wrap your app
      ),
    ),
  );
}

class MovieApp extends StatefulWidget {
  const MovieApp({super.key});

  @override
  State<MovieApp> createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie DB App',
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder, // Integrates with device_preview
      locale: DevicePreview.locale(context), // <== Important!
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color.fromRGBO(18, 16, 18, 1),
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
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: MainPage(),
    );
  }
}
