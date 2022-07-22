import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieWatchListState extends Equatable {}

class InitiateMovieWatchList extends MovieWatchListState {
  @override
  List<Object?> get props => [];
}

class MovieWatchListEmptyState extends MovieWatchListState {
  @override
  List<Object?> get props => [];
}

class MovieWatchListLoadingState extends MovieWatchListState {
  @override
  List<Object?> get props => [];
}

class MovieWatchListErrorState extends MovieWatchListState {
  final String message;

  MovieWatchListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieWatchListHasDataState extends MovieWatchListState {
  final List<Movie> movies;

  MovieWatchListHasDataState(this.movies);

  @override
  List<Object?> get props => [movies];
}

class MovieWatchListIsAddedState extends MovieWatchListState {
  final bool isAdded;

  MovieWatchListIsAddedState(this.isAdded);

  @override
  List<Object?> get props => [isAdded];
}

class MovieWatchListMessage extends MovieWatchListState {
  final String message;

  MovieWatchListMessage(this.message);

  @override
  List<Object?> get props => [message];
}