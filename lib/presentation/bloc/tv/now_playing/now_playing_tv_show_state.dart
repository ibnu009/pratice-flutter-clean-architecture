import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowNowPlayingState extends Equatable {}

class TvShowNowPlayingEmptyState extends TvShowNowPlayingState {
  @override
  List<Object?> get props => [];
}

class TvShowNowPlayingLoadingState extends TvShowNowPlayingState {
  @override
  List<Object?> get props => [];
}

class TvShowNowPlayingErrorState extends TvShowNowPlayingState {
  final String message;

  TvShowNowPlayingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowNowPlayingHasDataState extends TvShowNowPlayingState {
  final List<TvShow> tvShows;

  TvShowNowPlayingHasDataState(this.tvShows);

  @override
  // TODO: implement props
  List<Object?> get props => [tvShows];
}