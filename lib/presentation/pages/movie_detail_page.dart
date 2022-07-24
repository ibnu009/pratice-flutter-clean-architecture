import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_state.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_state.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;

  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(OnGetMovieDetail(widget.id));
      context
          .read<MovieRecommendationBloc>()
          .add(OnGetMovieRecommendationEvent(widget.id));
      context.read<MovieWatchListBloc>().add(MovieWatchListStatus(widget.id));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is MovieDetailHasDataState) {
            final movie = state.movie;
            return SafeArea(
              child: StreamBuilder(
                stream:
                    context.read<MovieWatchListBloc>().liveIsAddedToWatchList,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return DetailContent(
                    movie,
                    snapshot.data ?? false,
                  );
                },
                initialData: getAddedWatchListStatus(context),
              ),
            );
          }

          if (state is MovieDetailErrorState) {
            return Text(state.message);
          }

          return SizedBox();
        },
      ),
    );
  }
}

bool getAddedWatchListStatus(BuildContext context) {
  final state = BlocProvider.of<MovieWatchListBloc>(context).state;
  if (state is MovieWatchListIsAddedState) {
    return state.isAdded;
  }

  return false;
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;

  DetailContent(this.movie, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async =>
                                  _onClickWatchListButton(context),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _buildRecommendationList()
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onClickWatchListButton(BuildContext context) async {
    if (!isAddedWatchlist) {
      context.read<MovieWatchListBloc>().add(MovieWatchListAdd(movie));
    } else {
      context.read<MovieWatchListBloc>().add(MovieWatchListRemove(movie));
    }

    String message = "";
    message = isAddedWatchlist
        ? watchlistRemoveSuccessMessage
        : watchlistAddSuccessMessage;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildRecommendationList() {
    return BlocBuilder<MovieRecommendationBloc, MovieRecommendationState>(
      builder: (context, state) {
        if (state is MovieRecommendationLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MovieRecommendationHasDataState) {
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MovieDetailPage.ROUTE_NAME,
                        arguments: movie.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              itemCount: state.movies.length,
            ),
          );
        }

        if (state is MovieRecommendationErrorState) {
          return Text(state.message);
        }

        return SizedBox();
      },
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
