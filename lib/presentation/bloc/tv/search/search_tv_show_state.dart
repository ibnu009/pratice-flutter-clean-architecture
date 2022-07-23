import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowSearchState extends Equatable {}

class TvShowSearchEmptyState extends TvShowSearchState {
  @override
  List<Object?> get props => [];
}

class TvShowSearchLoadingState extends TvShowSearchState {
  @override
  List<Object?> get props => [];
}

class TvShowSearchErrorState extends TvShowSearchState {
  final String message;

  TvShowSearchErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowSearchHasDataState extends TvShowSearchState {
  final List<TvShow> tvShows;

  TvShowSearchHasDataState(this.tvShows);

  @override
  // TODO: implement props
  List<Object?> get props => [tvShows];
}