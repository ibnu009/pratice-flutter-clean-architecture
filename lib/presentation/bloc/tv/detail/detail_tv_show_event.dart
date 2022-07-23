import 'package:equatable/equatable.dart';

abstract class TvShowDetailEvent extends Equatable {}

class OnGetTvShowDetail extends TvShowDetailEvent {
  final int id;

  OnGetTvShowDetail(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}