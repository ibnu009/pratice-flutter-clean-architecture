import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-show';

  @override
  _TopRatedTvShowsPageState createState() => _TopRatedTvShowsPageState();
}

class _TopRatedTvShowsPageState extends State<TopRatedTvShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<TvShowTopRatedBloc>(context, listen: false)
            .add(OnGetTvShowTopRatedEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TvShows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvShowTopRatedBloc, TvShowTopRatedState>(
          builder: (context, state) {
            if (state is TvShowTopRatedLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is TvShowTopRatedHasDataState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.tvShows[index];
                  return TvShowCard(movie);
                },
                itemCount: state.tvShows.length,
              );
            }

            if (state is TvShowTopRatedErrorState) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
}
