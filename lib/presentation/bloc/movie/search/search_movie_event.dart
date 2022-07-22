import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {}

class OnSearchMovieEvent extends MovieSearchEvent {
  final String query;
  OnSearchMovieEvent(this.query);

  @override
  List<Object?> get props => [query];
}