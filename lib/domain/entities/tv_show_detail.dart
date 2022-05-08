import 'package:ditonton/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

class TvShowDetail extends Equatable {
  TvShowDetail({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    required this.numberOfEpisodes
  });

  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;
  final int voteCount;
  final int numberOfEpisodes;

  @override
  List<Object?> get props => [
        backdropPath,
        genres,
        id,
        originalTitle,
        overview,
        posterPath,
        releaseDate,
        title,
        voteAverage,
        voteCount,
        numberOfEpisodes
      ];
}
