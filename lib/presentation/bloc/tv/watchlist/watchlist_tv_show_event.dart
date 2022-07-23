import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowWatchListEvent extends Equatable {}

class OnGetTvShowWatchList extends TvShowWatchListEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TvShowWatchListStatus extends TvShowWatchListEvent {
  final int id;

  TvShowWatchListStatus(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class TvShowWatchListAdd extends TvShowWatchListEvent {
  final TvShowDetail tvShowDetail;

  TvShowWatchListAdd(this.tvShowDetail);

  @override
  // TODO: implement props
  List<Object?> get props => [tvShowDetail];
}

class TvShowWatchListRemove extends TvShowWatchListEvent {
  final TvShowDetail tvShowDetail;

  TvShowWatchListRemove(this.tvShowDetail);

  @override
  // TODO: implement props
  List<Object?> get props => [tvShowDetail];
}