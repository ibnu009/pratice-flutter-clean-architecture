import 'package:equatable/equatable.dart';

abstract class MovieTopRatedEvent extends Equatable {}

class OnGetMovieTopRatedEvent extends MovieTopRatedEvent {
  @override
  List<Object?> get props => [];
}