import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieWatchListEvent extends Equatable {}

class OnGetMovieWatchList extends MovieWatchListEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MovieWatchListStatus extends MovieWatchListEvent {
  final int id;

  MovieWatchListStatus(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class MovieWatchListAdd extends MovieWatchListEvent {
  final MovieDetail movieDetail;

  MovieWatchListAdd(this.movieDetail);

  @override
  // TODO: implement props
  List<Object?> get props => [movieDetail];
}

class MovieWatchListRemove extends MovieWatchListEvent {
  final MovieDetail movieDetail;

  MovieWatchListRemove(this.movieDetail);

  @override
  // TODO: implement props
  List<Object?> get props => [movieDetail];
}