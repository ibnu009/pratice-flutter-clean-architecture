import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailState extends Equatable {}

class MovieDetailEmptyState extends MovieDetailState {
  @override
  List<Object?> get props => [];
}

class MovieDetailLoadingState extends MovieDetailState {
  @override
  List<Object?> get props => [];
}

class MovieDetailErrorState extends MovieDetailState {
  final String message;

  MovieDetailErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieDetailHasDataState extends MovieDetailState {
  final MovieDetail movie;

  MovieDetailHasDataState(this.movie);

  @override
  List<Object?> get props => [movie];
}