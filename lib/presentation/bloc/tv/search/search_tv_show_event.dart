import 'package:equatable/equatable.dart';

abstract class TvShowSearchEvent extends Equatable {}

class OnSearchTvShowEvent extends TvShowSearchEvent {
  final String query;
  OnSearchTvShowEvent(this.query);

  @override
  List<Object?> get props => [query];
}