import 'package:equatable/equatable.dart';

abstract class MovieRecommendationEvent extends Equatable {}

class OnGetMovieRecommendationEvent extends MovieRecommendationEvent {
  final int id;

  OnGetMovieRecommendationEvent(this.id);
  @override
  List<Object?> get props => [];
}