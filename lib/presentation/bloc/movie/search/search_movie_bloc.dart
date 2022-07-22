import 'dart:async';

import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies _getSearchMovies;

  MovieSearchBloc(this._getSearchMovies)
      : super(MovieSearchEmptyState()) {
    on<OnSearchMovieEvent>(_onMovieSearch);
  }

  FutureOr<void> _onMovieSearch(
      OnSearchMovieEvent event, Emitter<MovieSearchState> emit) async {
    emit(MovieSearchLoadingState());

    final result = await _getSearchMovies.execute(event.query);

    result.fold((failure) {
      emit(MovieSearchErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(MovieSearchHasDataState(success))
          : emit(MovieSearchEmptyState());
    });
  }
}