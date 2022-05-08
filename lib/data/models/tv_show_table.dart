import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

class TvShowTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;

  TvShowTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  factory TvShowTable.fromEntity(TvShowDetail tvShow) => TvShowTable(
      id: tvShow.id,
      title: tvShow.originalTitle,
      posterPath: tvShow.posterPath,
      overview: tvShow.overview);

  factory TvShowTable.fromMap(Map<String, dynamic> map) => TvShowTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
      };

  TvShow toEntity() => TvShow.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, posterPath, overview];
}
