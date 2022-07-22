import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_state.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_state.dart';

class MovieWatchListBloc
    extends Bloc<MovieWatchListEvent, MovieWatchListState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _getWatchListStatus;
  final RemoveWatchlist _removeWatchlist;
  final SaveWatchlist _saveWatchlist;

  bool _isAddedToWatchList = false;
  final _isAddedToWatchListStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get _liveChatController =>
      _isAddedToWatchListStreamController.sink;
  Stream<bool> get liveIsAddedToWatchList => _isAddedToWatchListStreamController.stream;

  MovieWatchListBloc(this._getWatchlistMovies, this._getWatchListStatus,
      this._removeWatchlist, this._saveWatchlist)
      : super(InitiateMovieWatchList()) {
    on<OnGetMovieWatchList>(_onFetchMovieWatchList);
    on<MovieWatchListStatus>(_onMovieWatchListStatus);
    on<MovieWatchListAdd>(_onMovieWatchListAdd);
    on<MovieWatchListRemove>(_onMovieWatchListRemove);
  }

  FutureOr<void> _onFetchMovieWatchList(
      OnGetMovieWatchList event, Emitter<MovieWatchListState> emit) async {
    emit(MovieWatchListLoadingState());
    final result = await _getWatchlistMovies.execute();

    result.fold((failure) {
      emit(MovieWatchListErrorState(failure.message));
    }, (success) {
      success.isNotEmpty
          ? emit(MovieWatchListHasDataState(success))
          : emit(MovieWatchListEmptyState());
    });
  }

  FutureOr<void> _onMovieWatchListStatus(
      MovieWatchListStatus event, Emitter<MovieWatchListState> emit) async {
    final id = event.id;
    final result = await _getWatchListStatus.execute(id);
    _liveChatController.add(result);

    emit(MovieWatchListIsAddedState(result));
  }

  FutureOr<void> _onMovieWatchListAdd(
      MovieWatchListAdd event, Emitter<MovieWatchListState> emit) async {
    final movie = event.movieDetail;

    _isAddedToWatchList = true;
    _liveChatController.add(_isAddedToWatchList);

    final result = await _saveWatchlist.execute(movie);
    result.fold((failure) {
      emit(MovieWatchListErrorState(failure.message));
    }, (success) {
      emit(MovieWatchListMessage(success));
    });
  }

  FutureOr<void> _onMovieWatchListRemove(
      MovieWatchListRemove event, Emitter<MovieWatchListState> emit) async {
    final movie = event.movieDetail;

    _isAddedToWatchList = false;
    _liveChatController.add(_isAddedToWatchList);

    final result = await _removeWatchlist.execute(movie);
    result.fold((failure) {
      emit(MovieWatchListErrorState(failure.message));
    }, (success) {
      emit(MovieWatchListMessage(success));
    });
  }

  void dispose() {
    _isAddedToWatchListStreamController.close();
  }
}
