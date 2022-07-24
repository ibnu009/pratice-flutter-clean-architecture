import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with RouteAware {
  String _selectedType = watchListMovieType;

  @override
  void initState() {
    super.initState();
    _fetchMovieWatchList();
  }

  void didPopNext() {
    _selectedType == watchListMovieType ?
    _fetchMovieWatchList():
    _fetchTvShowWatchList();
  }

  void _fetchMovieWatchList(){
    Future.microtask(() =>
        Provider.of<MovieWatchListBloc>(context, listen: false)
            .add(OnGetMovieWatchList()));
  }

  void _fetchTvShowWatchList(){
    Future.microtask(() =>
        Provider.of<TvShowWatchListBloc>(context, listen: false)
            .add(OnGetTvShowWatchList()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        actions: [
          IconButton(
              onPressed: () => chooseWatchList(), icon: Icon(Icons.settings))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _selectedType == watchListMovieType
              ? MovieWatchList()
              : TvShowWatchList()),
    );
  }

  void chooseWatchList() {
    showDialog(
        context: context,
        builder: (ctx) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const Text("Choose your watchlist type",
                            style: TextStyle(fontSize: 16)),
                      ),
                      InkWell(
                        onTap: () {
                          _fetchMovieWatchList();
                          setState(() {
                            _selectedType = watchListMovieType;
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(children: [
                            Icon(Icons.movie, size: 24, color: Colors.black),
                            SizedBox(width: 16),
                            Text("Movie", style: TextStyle(fontSize: 16))
                          ]),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _fetchTvShowWatchList();
                          setState(() {
                            _selectedType = watchListTvShowType;
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(children: [
                            Icon(Icons.tv, size: 24, color: Colors.black),
                            SizedBox(width: 16),
                            Text("Tv Show", style: TextStyle(fontSize: 16))
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

class MovieWatchList extends StatelessWidget {
  const MovieWatchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieWatchListBloc, MovieWatchListState>(
      builder: (context, state) {
        if (state is MovieWatchListLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MovieWatchListHasDataState) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return MovieCard(movie);
            },
            itemCount: state.movies.length,
          );
        }

        if (state is MovieWatchListErrorState) {
          return Center(
            key: Key('error_message'),
            child: Text(state.message),
          );
        }

        return SizedBox();
      },
    );
  }
}

class TvShowWatchList extends StatelessWidget {
  const TvShowWatchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowWatchListBloc, TvShowWatchListState>(
      builder: (context, state) {
        if (state is TvShowWatchListLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is TvShowWatchListHasDataState) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = state.tvShows[index];
              return TvShowCard(movie);
            },
            itemCount: state.tvShows.length,
          );
        }

        if (state is TvShowWatchListErrorState) {
          return Center(
            key: Key('error_message'),
            child: Text(state.message),
          );
        }

        return SizedBox();
      },
    );
  }
}
