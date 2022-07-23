import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_state.dart';

class TvShowWatchListBloc
    extends Bloc<TvShowWatchListEvent, TvShowWatchListState> {
  final GetWatchlistTvShows _getWatchlistTvShows;
  final GetWatchListTvShowStatus _getWatchListStatus;
  final RemoveTvShowWatchlist _removeWatchlist;
  final SaveTvShowWatchlist _saveWatchlist;

  bool _isAddedToWatchList = false;
  final _isAddedToWatchListStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get _liveChatController =>
      _isAddedToWatchListStreamController.sink;
  Stream<bool> get liveIsAddedToWatchList => _isAddedToWatchListStreamController.stream;

  TvShowWatchListBloc(this._getWatchlistTvShows, this._getWatchListStatus,
      this._removeWatchlist, this._saveWatchlist)
      : super(InitiateTvShowWatchList()) {
    on<OnGetTvShowWatchList>(_onFetchTvShowWatchList);
    on<TvShowWatchListStatus>(_onTvShowWatchListStatus);
    on<TvShowWatchListAdd>(_onTvShowWatchListAdd);
    on<TvShowWatchListRemove>(_onTvShowWatchListRemove);
  }

  FutureOr<void> _onFetchTvShowWatchList(
      OnGetTvShowWatchList event, Emitter<TvShowWatchListState> emit) async {
    emit(TvShowWatchListLoadingState());
    final result = await _getWatchlistTvShows.execute();

    result.fold((failure) {
      emit(TvShowWatchListErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(TvShowWatchListHasDataState(success))
          : emit(TvShowWatchListEmptyState());
    });
  }

  FutureOr<void> _onTvShowWatchListStatus(
      TvShowWatchListStatus event, Emitter<TvShowWatchListState> emit) async {
    final id = event.id;
    final result = await _getWatchListStatus.execute(id);
    _liveChatController.add(result);

    emit(TvShowWatchListIsAddedState(result));
  }

  FutureOr<void> _onTvShowWatchListAdd(
      TvShowWatchListAdd event, Emitter<TvShowWatchListState> emit) async {
    final tvShow = event.tvShowDetail;

    _isAddedToWatchList = true;
    _liveChatController.add(_isAddedToWatchList);

    final result = await _saveWatchlist.execute(tvShow);
    result.fold((failure) {
      emit(TvShowWatchListErrorState(failure.message));
    }, (success) {
      emit(TvShowWatchListMessage(success));
    });
  }

  FutureOr<void> _onTvShowWatchListRemove(
      TvShowWatchListRemove event, Emitter<TvShowWatchListState> emit) async {
    final tvShow = event.tvShowDetail;

    _isAddedToWatchList = false;
    _liveChatController.add(_isAddedToWatchList);

    final result = await _removeWatchlist.execute(tvShow);
    result.fold((failure) {
      emit(TvShowWatchListErrorState(failure.message));
    }, (success) {
      emit(TvShowWatchListMessage(success));
    });
  }

  void dispose() {
    _isAddedToWatchListStreamController.close();
  }
}
