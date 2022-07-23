import 'package:equatable/equatable.dart';

abstract class TvShowRecommendationEvent extends Equatable {}

class OnGetTvShowRecommendationEvent extends TvShowRecommendationEvent {
  final int id;

  OnGetTvShowRecommendationEvent(this.id);
  @override
  List<Object?> get props => [];
}