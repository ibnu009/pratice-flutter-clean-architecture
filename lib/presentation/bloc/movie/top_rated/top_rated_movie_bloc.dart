import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_state.dart';

class MovieTopRatedBloc extends Bloc<MovieTopRatedEvent, MovieTopRatedState> {
  final GetTopRatedMovies _getTopRatedMovies;

  MovieTopRatedBloc(this._getTopRatedMovies)
      : super(MovieTopRatedEmptyState()) {
    on<OnGetMovieTopRatedEvent>(_onMovieTopRated);
  }

  FutureOr<void> _onMovieTopRated(
      OnGetMovieTopRatedEvent event, Emitter<MovieTopRatedState> emit) async {
    emit(MovieTopRatedLoadingState());

    final result = await _getTopRatedMovies.execute();

    result.fold((failure) {
      emit(MovieTopRatedErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(MovieTopRatedHasDataState(success))
          : emit(MovieTopRatedEmptyState());
    });
  }
}
