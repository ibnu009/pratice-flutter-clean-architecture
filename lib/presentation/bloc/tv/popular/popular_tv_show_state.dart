import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowPopularState extends Equatable {}

class TvShowPopularEmptyState extends TvShowPopularState {
  @override
  List<Object?> get props => [];
}

class TvShowPopularLoadingState extends TvShowPopularState {
  @override
  List<Object?> get props => [];
}

class TvShowPopularErrorState extends TvShowPopularState {
  final String message;

  TvShowPopularErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowPopularHasDataState extends TvShowPopularState {
  final List<TvShow> tvShows;

  TvShowPopularHasDataState(this.tvShows);

  @override
  // TODO: implement props
  List<Object?> get props => [tvShows];
}