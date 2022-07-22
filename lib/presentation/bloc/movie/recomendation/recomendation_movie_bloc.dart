import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_state.dart';

class MovieRecommendationBloc extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations _getRecommendationMovies;

  MovieRecommendationBloc(this._getRecommendationMovies)
      : super(MovieRecommendationEmptyState()) {
    on<OnGetMovieRecommendationEvent>(_onMovieRecommendation);
  }

  FutureOr<void> _onMovieRecommendation(
      OnGetMovieRecommendationEvent event, Emitter<MovieRecommendationState> emit) async {
    emit(MovieRecommendationLoadingState());

    final result = await _getRecommendationMovies.execute(event.id);

    result.fold((failure) {
      emit(MovieRecommendationErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(MovieRecommendationHasDataState(success))
          : emit(MovieRecommendationEmptyState());
    });
  }
}
