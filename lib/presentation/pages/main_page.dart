import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/presentation/pages/home_page.dart';
import 'package:trelpix/presentation/pages/saved_movies_page.dart';
import 'package:trelpix/presentation/pages/search_page.dart';
import 'package:trelpix/presentation/widgets/my_drawer.dart';
import 'package:trelpix/providers/navigation_provider.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final pages = [const HomePage(), const SavedMoviesPage()];

    return Platform.isIOS
        ? CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            currentIndex: currentIndex,
            onTap:
                (index) =>
                    ref.read(bottomNavIndexProvider.notifier).state = index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bookmark),
                label: 'Saved',
              ),
            ],
          ),
          tabBuilder: (context, index) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(index == 0 ? 'Home' : 'Saved'),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const SearchPage()),
                    );
                  },
                  child: const Icon(CupertinoIcons.search),
                ),
              ),
              child: SafeArea(child: pages[index]),
            );
          },
        )
        : Scaffold(
          drawer: const MyDrawer(),
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedIconTheme: IconThemeData(
              color: ThemeData.dark().colorScheme.primary,
            ),
            currentIndex: currentIndex,
            selectedItemColor: ThemeData.dark().colorScheme.primary,
            onTap:
                (index) =>
                    ref.read(bottomNavIndexProvider.notifier).state = index,
            items: const [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.bookmark),
                icon: Icon(Icons.bookmark_outline_rounded),
                label: 'Saved',
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: const Icon(Icons.search),
          ),
        );
  }
}
