import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MoviePopularState extends Equatable {}

class MoviePopularEmptyState extends MoviePopularState {
  @override
  List<Object?> get props => [];
}

class MoviePopularLoadingState extends MoviePopularState {
  @override
  List<Object?> get props => [];
}

class MoviePopularErrorState extends MoviePopularState {
  final String message;

  MoviePopularErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class MoviePopularHasDataState extends MoviePopularState {
  final List<Movie> movies;

  MoviePopularHasDataState(this.movies);

  @override
  // TODO: implement props
  List<Object?> get props => [movies];
}