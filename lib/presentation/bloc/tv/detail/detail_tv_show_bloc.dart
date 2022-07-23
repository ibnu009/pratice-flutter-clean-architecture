import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv/detail/detail_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/detail/detail_tv_show_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowDetail _getTvShowDetail;

  TvShowDetailBloc(this._getTvShowDetail) : super(TvShowDetailEmptyState()) {
    on<OnGetTvShowDetail>(_onTvShowDetail);
  }

  FutureOr<void> _onTvShowDetail(
      OnGetTvShowDetail event, Emitter<TvShowDetailState> emit) async {
    final id = event.id;

    emit(TvShowDetailLoadingState());
    final result = await _getTvShowDetail.execute(id);

    result.fold((failure) {
      emit(TvShowDetailErrorState(failure.message));
    }, (success) {
      emit(TvShowDetailHasDataState(success));
    });
  }
}
