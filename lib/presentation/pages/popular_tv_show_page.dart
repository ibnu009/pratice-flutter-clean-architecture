import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_state.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-show';

  @override
  _PopularTvShowsPageState createState() => _PopularTvShowsPageState();
}

class _PopularTvShowsPageState extends State<PopularTvShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TvShowPopularBloc>(context, listen: false)
            .add(OnGetTvShowPopularEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TvShows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvShowPopularBloc, TvShowPopularState>(
          builder: (context, state) {
            if (state is TvShowPopularLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is TvShowPopularHasDataState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.tvShows[index];
                  return TvShowCard(movie);
                },
                itemCount: state.tvShows.length,
              );
            }

            if (state is TvShowPopularEmptyState){
              return Center(
                key: Key('empty_message'),
                child: Text("Popular tv shows is empty!"),
              );
            }

            if (state is TvShowPopularErrorState) {
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
