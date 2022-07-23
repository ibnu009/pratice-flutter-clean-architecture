import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_show_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  BlocProvider.of<MovieSearchBloc>(context, listen: false)
                      .add(OnSearchMovieEvent(query));
                } else {
                  BlocProvider.of<TvShowSearchBloc>(context, listen: false)
                      .add(OnSearchTvShowEvent(query));
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
    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
      builder: (context, state) {
        print('state is $state');
        if (state is MovieSearchLoadingState) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is MovieSearchHasDataState) {
          final result = state.movies;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = result[index];
                return MovieCard(movie);
              },
              itemCount: result.length,
            ),
          );
        }

        if (state is MovieSearchEmptyState){
          return Expanded(
            child: Center(child: Text("No Data")),
          );
        }

        return SizedBox();
      },
    );
  }
}

class SearchTvShowResult extends StatelessWidget {
  const SearchTvShowResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowSearchBloc, TvShowSearchState>(
      builder: (context, state) {
        print('state is $state');
        if (state is TvShowSearchLoadingState) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is TvShowSearchHasDataState) {
          final result = state.tvShows;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tvShow = result[index];
                return TvShowCard(tvShow);
              },
              itemCount: result.length,
            ),
          );
        }

        if (state is TvShowSearchEmptyState){
          return Expanded(
            child: Center(child: Text("No Data")),
          );
        }

        return SizedBox();
      },
    );
  }
}
