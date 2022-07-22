import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {}

class OnGetMovieDetail extends MovieDetailEvent {
  final int id;

  OnGetMovieDetail(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}