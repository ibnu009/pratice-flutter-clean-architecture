import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowTopRatedState extends Equatable {}

class TvShowTopRatedEmptyState extends TvShowTopRatedState {
  @override
  List<Object?> get props => [];
}

class TvShowTopRatedLoadingState extends TvShowTopRatedState {
  @override
  List<Object?> get props => [];
}

class TvShowTopRatedErrorState extends TvShowTopRatedState {
  final String message;

  TvShowTopRatedErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowTopRatedHasDataState extends TvShowTopRatedState {
  final List<TvShow> tvShows;

  TvShowTopRatedHasDataState(this.tvShows);

  @override
  // TODO: implement props
  List<Object?> get props => [tvShows];
}
