import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowWatchListState extends Equatable {}

class InitiateTvShowWatchList extends TvShowWatchListState {
  @override
  List<Object?> get props => [];
}

class TvShowWatchListEmptyState extends TvShowWatchListState {
  @override
  List<Object?> get props => [];
}

class TvShowWatchListLoadingState extends TvShowWatchListState {
  @override
  List<Object?> get props => [];
}

class TvShowWatchListErrorState extends TvShowWatchListState {
  final String message;

  TvShowWatchListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowWatchListHasDataState extends TvShowWatchListState {
  final List<TvShow> tvShows;

  TvShowWatchListHasDataState(this.tvShows);

  @override
  List<Object?> get props => [tvShows];
}

class TvShowWatchListIsAddedState extends TvShowWatchListState {
  final bool isAdded;

  TvShowWatchListIsAddedState(this.isAdded);

  @override
  List<Object?> get props => [isAdded];
}

class TvShowWatchListMessage extends TvShowWatchListState {
  final String message;

  TvShowWatchListMessage(this.message);

  @override
  List<Object?> get props => [message];
}