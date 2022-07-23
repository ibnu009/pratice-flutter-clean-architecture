import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowRecommendationState extends Equatable {}

class TvShowRecommendationEmptyState extends TvShowRecommendationState {
  @override
  List<Object?> get props => [];
}

class TvShowRecommendationLoadingState extends TvShowRecommendationState {
  @override
  List<Object?> get props => [];
}

class TvShowRecommendationErrorState extends TvShowRecommendationState {
  final String message;

  TvShowRecommendationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowRecommendationHasDataState extends TvShowRecommendationState {
  final List<TvShow> tvShows;

  TvShowRecommendationHasDataState(this.tvShows);

  @override
  // TODO: implement props
  List<Object?> get props => [tvShows];
}