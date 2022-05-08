import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist.dart';
import 'package:flutter/cupertino.dart';

class TvShowDetailNotifier extends ChangeNotifier {
  final GetTvShowDetail getTvShowDetail;
  final GetTvShowRecommendations getTvShowRecommendations;
  final GetWatchListTvShowStatus getWatchListStatus;
  final SaveTvShowWatchlist saveWatchlist;
  final RemoveTvShowWatchlist removeWatchlist;

  TvShowDetailNotifier(
      {required this.getTvShowDetail, required this.getTvShowRecommendations,required this.getWatchListStatus,required this.saveWatchlist, required this.removeWatchlist,});

  late TvShowDetail _tvShow;

  TvShowDetail get tvShow => _tvShow;

  RequestState _tvShowState = RequestState.Empty;

  RequestState get tvShowState => _tvShowState;

  List<TvShow> _tvShowRecommendations = [];

  List<TvShow> get tvShowRecommendations => _tvShowRecommendations;

  RequestState _recommendationState = RequestState.Empty;

  RequestState get recommendationState => _recommendationState;

  String _message = '';

  String get message => _message;

  Future<void> fetchTvShowDetail(int id) async {
    _tvShowState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvShowDetail.execute(id);
    final recommendationResult = await getTvShowRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvShowState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _tvShow = tv;
        _tvShowState = RequestState.Loaded;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvShowsRecommendation) {
            _recommendationState = RequestState.Loaded;
            _tvShowRecommendations = tvShowsRecommendation;
          },
        );
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';

  String get watchlistMessage => _watchlistMessage;

  bool _isAddedtoWatchlist = false;

  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> addWatchlist(TvShowDetail movie) async {
    final result = await saveWatchlist.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(TvShowDetail movie) async {
    final result = await removeWatchlist.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
