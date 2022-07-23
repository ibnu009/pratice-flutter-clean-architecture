import 'dart:async';

import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_shows.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_show_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvShowSearchBloc extends Bloc<TvShowSearchEvent, TvShowSearchState> {
  final SearchTvShows _getSearchTvShows;

  TvShowSearchBloc(this._getSearchTvShows)
      : super(TvShowSearchEmptyState()) {
    on<OnSearchTvShowEvent>(_onTvShowSearch);
  }

  FutureOr<void> _onTvShowSearch(
      OnSearchTvShowEvent event, Emitter<TvShowSearchState> emit) async {
    emit(TvShowSearchLoadingState());

    final result = await _getSearchTvShows.execute(event.query);

    result.fold((failure) {
      emit(TvShowSearchErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(TvShowSearchHasDataState(success))
          : emit(TvShowSearchEmptyState());
    });
  }
}