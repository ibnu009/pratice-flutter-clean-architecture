import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_state.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_state.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing/now_playing_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing/now_playing_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing/now_playing_tv_show_state.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_state.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_state.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_show_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isShowingMovie = true;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() {
    Future.microtask(() {
      context.read<MovieNowPlayingBloc>().add(OnGetMovieNowPlayingEvent());
      context.read<MovieTopRatedBloc>().add(OnGetMovieTopRatedEvent());
      context.read<MoviePopularBloc>().add(OnGetMoviePopularEvent());
    });
  }

  void _fetchTvShows() {
    Future.microtask(() {
      context.read<TvShowNowPlayingBloc>().add(OnGetTvShowNowPlayingEvent());
      context.read<TvShowTopRatedBloc>().add(OnGetTvShowTopRatedEvent());
      context.read<TvShowPopularBloc>().add(OnGetTvShowPopularEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/img_circle.png'),
              ),
              accountName: Text('Ibnu Batutah'),
              accountEmail: Text('ibnubatutah001@gmail.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _isShowingMovie = true;
                });
                _fetchMovies();
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Shows'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _isShowingMovie = false;
                });
                _fetchTvShows();
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME,
                  arguments:
                      _isShowingMovie ? searchMovieType : searchTvShowType);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: _isShowingMovie ? _buildMovieList() : _buildTvShowList(),
        ),
      ),
    );
  }

  Widget _buildMovieList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Now Playing',
          style: kHeading6,
        ),
        BlocBuilder<MovieNowPlayingBloc, MovieNowPlayingState>(
            builder: (context, state) {
          if (state is MovieNowPlayingLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is MovieNowPlayingHasDataState) {
            return MovieList(state.result);
          }

          if (state is MovieNowPlayingErrorState) {
            return Text(state.message);
          }
          return Text('Failed');
        }),

        _buildSubHeading(
          title: 'Popular Movies',
          onTap: () {
            // FirebaseCrashlytics.instance.crash();
            return Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME);
          },
        ),
        BlocBuilder<MoviePopularBloc, MoviePopularState>(
            builder: (context, state) {
              if (state is MoviePopularLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is MoviePopularHasDataState) {
                return MovieList(state.movies);
              }
              if (state is MoviePopularErrorState) {
                return Text(state.message);
              }

              return Text('Failed');
            }),

        _buildSubHeading(
          title: 'Top Rated Movies',
          onTap: () =>
              Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
        ),
        BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
            builder: (context, state) {
              if (state is MovieTopRatedLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is MovieTopRatedHasDataState) {
                return MovieList(state.movies);
              }
              if (state is MovieTopRatedErrorState) {
                return Text(state.message);
              }
              return Text('Failed');
            }),
      ],
    );
  }

  Widget _buildTvShowList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Airing Today',
          style: kHeading6,
        ),
        BlocBuilder<TvShowNowPlayingBloc, TvShowNowPlayingState>(
            builder: (context, state) {
              if (state is TvShowNowPlayingLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is TvShowNowPlayingHasDataState) {
                return TvShowList(state.tvShows);
              }
              if (state is TvShowNowPlayingErrorState){
                return Text(state.message);
              }
              return Text('Failed');
            }),

        _buildSubHeading(
          title: 'Popular TV Shows',
          onTap: () =>
              Navigator.pushNamed(context, PopularTvShowsPage.ROUTE_NAME),
        ),
        BlocBuilder<TvShowPopularBloc, TvShowPopularState>(
            builder: (context, state) {
              if (state is TvShowPopularLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is TvShowPopularHasDataState) {
                return TvShowList(state.tvShows);
              }

              if (state is TvShowPopularErrorState){
                return Text(state.message);
              }

              return Text('Failed');
            }),

        _buildSubHeading(
          title: 'Top Rated TV Shows',
          onTap: () =>
              Navigator.pushNamed(context, TopRatedTvShowsPage.ROUTE_NAME),
        ),
        BlocBuilder<TvShowTopRatedBloc, TvShowTopRatedState>(
            builder: (context, state) {
              if (state is TvShowTopRatedLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is TvShowTopRatedHasDataState) {
                return TvShowList(state.tvShows);
              }
              if (state is TvShowTopRatedErrorState){
                return Text(state.message);
              }
              return Text('Failed');
            }),
      ],
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvShowList extends StatelessWidget {
  final List<TvShow> tvShows;

  TvShowList(this.tvShows);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvShowDetailPage.ROUTE_NAME,
                  arguments: tvShow.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
