import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv/recomendation/recomendation_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/recomendation/recomendation_tv_show_state.dart';

class TvShowRecommendationBloc extends Bloc<TvShowRecommendationEvent, TvShowRecommendationState> {
  final GetTvShowRecommendations _getRecommendationTvShows;

  TvShowRecommendationBloc(this._getRecommendationTvShows)
      : super(TvShowRecommendationEmptyState()) {
    on<OnGetTvShowRecommendationEvent>(_onTvShowRecommendation);
  }

  FutureOr<void> _onTvShowRecommendation(
      OnGetTvShowRecommendationEvent event, Emitter<TvShowRecommendationState> emit) async {
    emit(TvShowRecommendationLoadingState());

    final result = await _getRecommendationTvShows.execute(event.id);

    result.fold((failure) {
      emit(TvShowRecommendationErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(TvShowRecommendationHasDataState(success))
          : emit(TvShowRecommendationEmptyState());
    });
  }
}
