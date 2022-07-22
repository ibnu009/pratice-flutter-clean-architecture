import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_state.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final GetPopularMovies _getPopularMovies;

  MoviePopularBloc(this._getPopularMovies)
      : super(MoviePopularEmptyState()) {
    on<OnGetMoviePopularEvent>(_onMoviePopular);
  }

  FutureOr<void> _onMoviePopular(
      OnGetMoviePopularEvent event, Emitter<MoviePopularState> emit) async {
    emit(MoviePopularLoadingState());

    final result = await _getPopularMovies.execute();

    result.fold((failure) {
      emit(MoviePopularErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(MoviePopularHasDataState(success))
          : emit(MoviePopularEmptyState());
    });
  }
}
