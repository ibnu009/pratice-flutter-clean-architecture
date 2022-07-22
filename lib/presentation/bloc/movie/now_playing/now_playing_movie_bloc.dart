import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_state.dart';

class MovieNowPlayingBloc extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  MovieNowPlayingBloc(this._getNowPlayingMovies)
      : super(MovieNowPlayingEmptyState()) {
    on<OnGetMovieNowPlayingEvent>(_onMovieNowPlaying);
  }

  FutureOr<void> _onMovieNowPlaying(
      OnGetMovieNowPlayingEvent event, Emitter<MovieNowPlayingState> emit) async {
    emit(MovieNowPlayingLoadingState());

    final result = await _getNowPlayingMovies.execute();

    result.fold((failure) {
      emit(MovieNowPlayingErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(MovieNowPlayingHasDataState(success))
          : emit(MovieNowPlayingEmptyState());
    });
  }
}
