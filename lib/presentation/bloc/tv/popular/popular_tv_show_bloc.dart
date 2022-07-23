import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_state.dart';

class TvShowPopularBloc extends Bloc<TvShowPopularEvent, TvShowPopularState> {
  final GetPopularTvShows _getPopularTvShows;

  TvShowPopularBloc(this._getPopularTvShows)
      : super(TvShowPopularEmptyState()) {
    on<OnGetTvShowPopularEvent>(_onTvShowPopular);
  }

  FutureOr<void> _onTvShowPopular(
      OnGetTvShowPopularEvent event, Emitter<TvShowPopularState> emit) async {
    emit(TvShowPopularLoadingState());

    final result = await _getPopularTvShows.execute();

    result.fold((failure) {
      emit(TvShowPopularErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(TvShowPopularHasDataState(success))
          : emit(TvShowPopularEmptyState());
    });
  }
}
