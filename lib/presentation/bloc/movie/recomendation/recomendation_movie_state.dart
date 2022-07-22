import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieRecommendationState extends Equatable {}

class MovieRecommendationEmptyState extends MovieRecommendationState {
  @override
  List<Object?> get props => [];
}

class MovieRecommendationLoadingState extends MovieRecommendationState {
  @override
  List<Object?> get props => [];
}

class MovieRecommendationErrorState extends MovieRecommendationState {
  final String message;

  MovieRecommendationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieRecommendationHasDataState extends MovieRecommendationState {
  final List<Movie> movies;

  MovieRecommendationHasDataState(this.movies);

  @override
  // TODO: implement props
  List<Object?> get props => [movies];
}