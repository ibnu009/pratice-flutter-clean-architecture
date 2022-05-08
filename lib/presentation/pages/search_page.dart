import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_show_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';
  final String searchType;

  SearchPage({required this.searchType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search $searchType'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                if (searchType == searchMovieType) {
                  Provider.of<MovieSearchNotifier>(context, listen: false)
                      .fetchMovieSearch(query);
                } else {
                  Provider.of<TvShowSearchNotifier>(context, listen: false)
                      .fetchTvShowSearch(query);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            searchType == searchMovieType
                ? SearchMovieResult()
                : SearchTvShowResult()
          ],
        ),
      ),
    );
  }
}

class SearchMovieResult extends StatelessWidget {
  const SearchMovieResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSearchNotifier>(
      builder: (context, data, child) {
        if (data.state == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.state == RequestState.Loaded) {
          final result = data.searchResult;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = data.searchResult[index];
                return MovieCard(movie);
              },
              itemCount: result.length,
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }
}

class SearchTvShowResult extends StatelessWidget {
  const SearchTvShowResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TvShowSearchNotifier>(
      builder: (context, data, child) {
        if (data.state == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.state == RequestState.Loaded) {
          final result = data.searchResult;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tvShow = data.searchResult[index];
                return TvShowCard(tvShow);
              },
              itemCount: result.length,
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }
}
