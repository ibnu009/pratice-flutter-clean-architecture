import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;

  MovieDetailBloc(this._getMovieDetail) : super(MovieDetailEmptyState()) {
    on<OnGetMovieDetail>(_onMovieDetail);
  }

  FutureOr<void> _onMovieDetail(
      OnGetMovieDetail event, Emitter<MovieDetailState> emit) async {
    final id = event.id;

    emit(MovieDetailLoadingState());
    final result = await _getMovieDetail.execute(id);

    result.fold((failure) {
      emit(MovieDetailErrorState(failure.message));
    }, (success) {
      emit(MovieDetailHasDataState(success));
    });
  }
}