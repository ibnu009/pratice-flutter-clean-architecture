import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowDetailState extends Equatable {}

class TvShowDetailEmptyState extends TvShowDetailState {
  @override
  List<Object?> get props => [];
}

class TvShowDetailLoadingState extends TvShowDetailState {
  @override
  List<Object?> get props => [];
}

class TvShowDetailErrorState extends TvShowDetailState {
  final String message;

  TvShowDetailErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowDetailHasDataState extends TvShowDetailState {
  final TvShowDetail tvShow;

  TvShowDetailHasDataState(this.tvShow);

  @override
  List<Object?> get props => [tvShow];
}