import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieNowPlayingState extends Equatable {}

class MovieNowPlayingEmptyState extends MovieNowPlayingState {
  @override
  List<Object?> get props => [];
}

class MovieNowPlayingLoadingState extends MovieNowPlayingState {
  @override
  List<Object?> get props => [];
}

class MovieNowPlayingErrorState extends MovieNowPlayingState {
  final String message;

  MovieNowPlayingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieNowPlayingHasDataState extends MovieNowPlayingState {
  final List<Movie> result;

  MovieNowPlayingHasDataState(this.result);

  @override
  // TODO: implement props
  List<Object?> get props => [result];
}