import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_show.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing/now_playing_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing/now_playing_tv_show_state.dart';

class TvShowNowPlayingBloc extends Bloc<TvShowNowPlayingEvent, TvShowNowPlayingState> {
  final GetNowPlayingTvShows _getNowPlayingTvShows;

  TvShowNowPlayingBloc(this._getNowPlayingTvShows)
      : super(TvShowNowPlayingEmptyState()) {
    on<OnGetTvShowNowPlayingEvent>(_onTvShowNowPlaying);
  }

  FutureOr<void> _onTvShowNowPlaying(
      OnGetTvShowNowPlayingEvent event, Emitter<TvShowNowPlayingState> emit) async {
    emit(TvShowNowPlayingLoadingState());

    final result = await _getNowPlayingTvShows.execute();

    result.fold((failure) {
      emit(TvShowNowPlayingErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(TvShowNowPlayingHasDataState(success))
          : emit(TvShowNowPlayingEmptyState());
    });
  }
}
