import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_show_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_show_list_notifier.dart';
import 'package:flutter/material.dart';
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
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
  }

  void _fetchTvShows() {
    Future.microtask(
            () => Provider.of<TvShowListNotifier>(context, listen: false)
          ..fetchNowPlayingTvShows()
          ..fetchPopularTvShows()
          ..fetchTopRatedTvShows());
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
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME, arguments: _isShowingMovie ? searchMovieType : searchTvShowType);
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
        Consumer<MovieListNotifier>(builder: (context, data, child) {
          final state = data.nowPlayingState;
          if (state == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == RequestState.Loaded) {
            return MovieList(data.nowPlayingMovies);
          } else {
            return Text('Failed');
          }
        }),
        _buildSubHeading(
          title: 'Popular Movies',
          onTap: () =>
              Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
        ),
        Consumer<MovieListNotifier>(builder: (context, data, child) {
          final state = data.popularMoviesState;
          if (state == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == RequestState.Loaded) {
            return MovieList(data.popularMovies);
          } else {
            return Text('Failed');
          }
        }),
        _buildSubHeading(
          title: 'Top Rated Movies',
          onTap: () =>
              Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
        ),
        Consumer<MovieListNotifier>(builder: (context, data, child) {
          final state = data.topRatedMoviesState;
          if (state == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == RequestState.Loaded) {
            return MovieList(data.topRatedMovies);
          } else {
            return Text('Failed');
          }
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
        Consumer<TvShowListNotifier>(builder: (context, data, child) {
          final state = data.nowPlayingState;
          if (state == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == RequestState.Loaded) {
            return TvShowList(data.nowPlayingTvShows);
          } else {
            return Text('Failed');
          }
        }),
        _buildSubHeading(
          title: 'Popular TV Shows',
          onTap: () =>
              Navigator.pushNamed(context, PopularTvShowsPage.ROUTE_NAME),
        ),
        Consumer<TvShowListNotifier>(builder: (context, data, child) {
          final state = data.popularTvShowsState;
          if (state == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == RequestState.Loaded) {
            return TvShowList(data.popularTvShows);
          } else {
            return Text('Failed');
          }
        }),
        _buildSubHeading(
          title: 'Top Rated TV Shows',
          onTap: () =>
              Navigator.pushNamed(context, TopRatedTvShowsPage.ROUTE_NAME),
        ),
        Consumer<TvShowListNotifier>(builder: (context, data, child) {
          final state = data.topRatedTvShowsState;
          if (state == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == RequestState.Loaded) {
            return TvShowList(data.topRatedTvShows);
          } else {
            return Text('Failed');
          }
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
