// lib/presentation/pages/main_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/presentation/pages/home_page.dart';
import 'package:trelpix/presentation/pages/saved_movies_page.dart';
import 'package:trelpix/providers/navigation_provider.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final pages = [const HomePage(), const SavedMoviesPage()];

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(
          color: ThemeData.dark().colorScheme.primary,
        ),
        currentIndex: currentIndex,
        selectedItemColor: ThemeData.dark().colorScheme.primary,

        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Hive.close(); // Close all open boxes before deleting
          await Hive.deleteFromDisk(); // Delete all Hive data from disk
        },
        child: const Icon(Icons.delete_forever, color: Colors.white),
      ),
    );
  }
}
