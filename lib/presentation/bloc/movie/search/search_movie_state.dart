import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieSearchState extends Equatable {}

class MovieSearchEmptyState extends MovieSearchState {
  @override
  List<Object?> get props => [];
}

class MovieSearchLoadingState extends MovieSearchState {
  @override
  List<Object?> get props => [];
}

class MovieSearchErrorState extends MovieSearchState {
  final String message;

  MovieSearchErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieSearchHasDataState extends MovieSearchState {
  final List<Movie> movies;

  MovieSearchHasDataState(this.movies);

  @override
  // TODO: implement props
  List<Object?> get props => [movies];
}