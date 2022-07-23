import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_state.dart';

class TvShowTopRatedBloc
    extends Bloc<TvShowTopRatedEvent, TvShowTopRatedState> {
  final GetTopRatedTvShows _getTopRatedTvShows;

  TvShowTopRatedBloc(this._getTopRatedTvShows)
      : super(TvShowTopRatedEmptyState()) {
    on<OnGetTvShowTopRatedEvent>(_onTvShowTopRated);
  }

  FutureOr<void> _onTvShowTopRated(
      OnGetTvShowTopRatedEvent event, Emitter<TvShowTopRatedState> emit) async {
    emit(TvShowTopRatedLoadingState());

    final result = await _getTopRatedTvShows.execute();

    result.fold((failure) {
      emit(TvShowTopRatedErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(TvShowTopRatedHasDataState(success))
          : emit(TvShowTopRatedEmptyState());
    });
  }
}
