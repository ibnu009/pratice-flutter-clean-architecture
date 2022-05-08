import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

class TvShowDetailResponse extends Equatable {
  TvShowDetailResponse(
      {required this.backdropPath,
      required this.numberOfEpisodes,
      required this.numberOfSeasons,
      required this.genres,
      required this.homepage,
      required this.id,
      required this.imdbId,
      required this.originalLanguage,
      required this.originalTitle,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.releaseDate,
      required this.status,
      required this.tagline,
      required this.title,
      required this.voteAverage,
      required this.voteCount,
      required this.inProduction});

  final String? backdropPath;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final String? imdbId;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String status;
  final String tagline;
  final String title;
  final double voteAverage;
  final int voteCount;
  final bool inProduction;

  factory TvShowDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvShowDetailResponse(
          backdropPath: json["backdrop_path"],
          numberOfEpisodes: json["number_of_episodes"],
          numberOfSeasons: json["number_of_seasons"],
          genres: List<GenreModel>.from(
              json["genres"].map((x) => GenreModel.fromJson(x))),
          homepage: json["homepage"],
          id: json["id"],
          imdbId: json["imdb_id"],
          originalLanguage: json["original_language"],
          originalTitle: json["original_name"],
          overview: json["overview"],
          popularity: json["popularity"].toDouble(),
          posterPath: json["poster_path"],
          releaseDate: json["first_air_date"],
          status: json["status"],
          tagline: json["tagline"],
          title: json["name"],
          voteAverage: json["vote_average"].toDouble(),
          voteCount: json["vote_count"],
          inProduction: json["in_production"]);

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "original_language": originalLanguage,
        "original_name": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "first_air_date": releaseDate,
        "status": status,
        "tagline": tagline,
        "name": title,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "in_production": inProduction
      };

  TvShowDetail toEntity() {
    return TvShowDetail(
      backdropPath: this.backdropPath,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      originalTitle: this.originalTitle,
      overview: this.overview,
      posterPath: this.posterPath,
      releaseDate: this.releaseDate,
      title: this.title,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
      numberOfEpisodes: this.numberOfEpisodes
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        backdropPath,
        numberOfEpisodes,
        numberOfSeasons,
        genres,
        homepage,
        id,
        imdbId,
        originalLanguage,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        status,
        tagline,
        title,
        voteAverage,
        voteCount,
        inProduction
      ];
}
