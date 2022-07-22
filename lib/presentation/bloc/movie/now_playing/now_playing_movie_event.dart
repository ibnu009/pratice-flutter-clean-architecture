import 'package:equatable/equatable.dart';

abstract class MovieNowPlayingEvent extends Equatable {}

class OnGetMovieNowPlayingEvent extends MovieNowPlayingEvent {
  @override
  List<Object?> get props => [];
}