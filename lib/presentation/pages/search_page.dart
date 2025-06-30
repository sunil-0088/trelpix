import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trelpix/presentation/pages/movie_detail_page.dart';
import 'package:trelpix/presentation/widgets/movie_card.dart';
import 'package:trelpix/providers/ui_providers.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchMoviesProvider.notifier).search(_searchController.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchField(BuildContext context) {
    return Platform.isIOS
        ? CupertinoSearchTextField(
          controller: _searchController,
          placeholder: 'Search for a movie...',
        )
        : TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for a movie...',
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(searchMoviesProvider);

    final searchContent = searchResultsAsync.when(
      loading:
          () => Center(
            child:
                Platform.isIOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
          ),
      error:
          (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error searching movies',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.redAccent),
              ),
            ),
          ),
      data: (movies) {
        if (_searchController.text.isEmpty) {
          return Center(
            child: Text(
              'Start typing to search for movies!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          );
        }
        if (movies.isEmpty) {
          return Center(
            child: Text(
              'No movies found for "${_searchController.text}".',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.7,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(
              movie: movie,
              onTap: () {
                Navigator.push(
                  context,
                  Platform.isIOS
                      ? CupertinoPageRoute(
                        builder:
                            (context) => MovieDetailPage(movieId: movie.id),
                      )
                      : MaterialPageRoute(
                        builder:
                            (context) => MovieDetailPage(movieId: movie.id),
                      ),
                );
              },
            );
          },
        );
      },
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Search Movies'),
            transitionBetweenRoutes: false,
            trailing: Icon(CupertinoIcons.search),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildSearchField(context),
                ),
                Expanded(child: searchContent),
              ],
            ),
          ),
        )
        : Scaffold(
          appBar: AppBar(
            title: Text(
              'Search Movies',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: _buildSearchField(context),
              ),
            ),
          ),
          body: searchContent,
        );
  }
}
