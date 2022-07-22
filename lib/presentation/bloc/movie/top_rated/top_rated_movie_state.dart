import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieTopRatedState extends Equatable {}

class MovieTopRatedEmptyState extends MovieTopRatedState {
  @override
  List<Object?> get props => [];
}

class MovieTopRatedLoadingState extends MovieTopRatedState {
  @override
  List<Object?> get props => [];
}

class MovieTopRatedErrorState extends MovieTopRatedState {
  final String message;

  MovieTopRatedErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieTopRatedHasDataState extends MovieTopRatedState {
  final List<Movie> movies;

  MovieTopRatedHasDataState(this.movies);

  @override
  // TODO: implement props
  List<Object?> get props => [movies];
}