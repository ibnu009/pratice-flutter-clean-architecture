import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/presentation/bloc/tv/detail/detail_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/detail/detail_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/detail/detail_tv_show_state.dart';
import 'package:ditonton/presentation/bloc/tv/recomendation/recomendation_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/recomendation/recomendation_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/recomendation/recomendation_tv_show_state.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvShowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';
  final int id;

  const TvShowDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TvShowDetailPageState createState() => _TvShowDetailPageState();
}

class _TvShowDetailPageState extends State<TvShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvShowDetailBloc>().add(OnGetTvShowDetail(widget.id));
      context
          .read<TvShowRecommendationBloc>()
          .add(OnGetTvShowRecommendationEvent(widget.id));
      context.read<TvShowWatchListBloc>().add(TvShowWatchListStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
        builder: (context, state) {
          if (state is TvShowDetailLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TvShowDetailHasDataState) {
            return SafeArea(
              child: StreamBuilder(
                stream: context.read<TvShowWatchListBloc>().liveIsAddedToWatchList,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return DetailContent(
                    state.tvShow,
                    snapshot.data ?? false,
                  );
                },
                initialData: getAddedWatchListStatus(context),
              ),
            );
          }

          if (state is TvShowDetailErrorState) {
            return Text(state.message);
          }

          return SizedBox();
        },
      ),
    );
  }
}

bool getAddedWatchListStatus(BuildContext context) {
  final state = BlocProvider.of<TvShowWatchListBloc>(context).state;
  if (state is TvShowWatchListIsAddedState) {
    return state.isAdded;
  }

  return false;
}

class DetailContent extends StatelessWidget {
  final TvShowDetail tvShow;
  final bool isAddedWatchlist;

  DetailContent(this.tvShow, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
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
                              tvShow.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: ()async => _onClickWatchListButton(context),
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
                              _showGenres(tvShow.genres),
                            ),
                            Text(
                              "${tvShow.numberOfEpisodes} total Episodes",
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvShow.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvShow.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvShow.overview,
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

  Widget _buildRecommendationList() {
    return BlocBuilder<TvShowRecommendationBloc, TvShowRecommendationState>(
      builder: (context, state) {
        if (state is TvShowRecommendationLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is TvShowRecommendationHasDataState) {
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movie = state.tvShows[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        TvShowDetailPage.ROUTE_NAME,
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
              itemCount: state.tvShows.length,
            ),
          );
        }

        if (state is TvShowRecommendationErrorState) {
          return Text(state.message);
        }

        return SizedBox();
      },
    );
  }


  Future<void> _onClickWatchListButton(BuildContext context) async {
    if (!isAddedWatchlist) {
      context.read<TvShowWatchListBloc>().add(TvShowWatchListAdd(tvShow));
    } else {
      context.read<TvShowWatchListBloc>().add(TvShowWatchListRemove(tvShow));
    }

    String message = "";
    message = isAddedWatchlist
        ? watchlistRemoveSuccessMessage
        : watchlistAddSuccessMessage;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
}
