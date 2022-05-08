// Mocks generated by Mockito 5.0.8 from annotations
// in ditonton/test/presentation/pages/movie_detail_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i11;
import 'dart:ui' as _i12;

import 'package:ditonton/common/state_enum.dart' as _i9;
import 'package:ditonton/domain/entities/movie.dart' as _i10;
import 'package:ditonton/domain/entities/movie_detail.dart' as _i7;
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart' as _i2;
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart' as _i3;
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart' as _i4;
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart' as _i6;
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart' as _i5;
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart'
    as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeGetMovieDetail extends _i1.Fake implements _i2.GetMovieDetail {}

class _FakeGetMovieRecommendations extends _i1.Fake
    implements _i3.GetMovieRecommendations {}

class _FakeGetWatchListStatus extends _i1.Fake
    implements _i4.GetWatchListStatus {}

class _FakeSaveWatchlist extends _i1.Fake implements _i5.SaveWatchlist {}

class _FakeRemoveWatchlist extends _i1.Fake implements _i6.RemoveWatchlist {}

class _FakeMovieDetail extends _i1.Fake implements _i7.MovieDetail {}

/// A class which mocks [MovieDetailNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockMovieDetailNotifier extends _i1.Mock
    implements _i8.MovieDetailNotifier {
  MockMovieDetailNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetMovieDetail get getMovieDetail =>
      (super.noSuchMethod(Invocation.getter(#getMovieDetail),
          returnValue: _FakeGetMovieDetail()) as _i2.GetMovieDetail);
  @override
  _i3.GetMovieRecommendations get getMovieRecommendations =>
      (super.noSuchMethod(Invocation.getter(#getMovieRecommendations),
              returnValue: _FakeGetMovieRecommendations())
          as _i3.GetMovieRecommendations);
  @override
  _i4.GetWatchListStatus get getWatchListStatus =>
      (super.noSuchMethod(Invocation.getter(#getWatchListStatus),
          returnValue: _FakeGetWatchListStatus()) as _i4.GetWatchListStatus);
  @override
  _i5.SaveWatchlist get saveWatchlist =>
      (super.noSuchMethod(Invocation.getter(#saveWatchlist),
          returnValue: _FakeSaveWatchlist()) as _i5.SaveWatchlist);
  @override
  _i6.RemoveWatchlist get removeWatchlist =>
      (super.noSuchMethod(Invocation.getter(#removeWatchlist),
          returnValue: _FakeRemoveWatchlist()) as _i6.RemoveWatchlist);
  @override
  _i7.MovieDetail get movie => (super.noSuchMethod(Invocation.getter(#movie),
      returnValue: _FakeMovieDetail()) as _i7.MovieDetail);
  @override
  _i9.RequestState get movieState =>
      (super.noSuchMethod(Invocation.getter(#movieState),
          returnValue: _i9.RequestState.Empty) as _i9.RequestState);
  @override
  List<_i10.Movie> get movieRecommendations =>
      (super.noSuchMethod(Invocation.getter(#movieRecommendations),
          returnValue: <_i10.Movie>[]) as List<_i10.Movie>);
  @override
  _i9.RequestState get recommendationState =>
      (super.noSuchMethod(Invocation.getter(#recommendationState),
          returnValue: _i9.RequestState.Empty) as _i9.RequestState);
  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);
  @override
  bool get isAddedToWatchlist =>
      (super.noSuchMethod(Invocation.getter(#isAddedToWatchlist),
          returnValue: false) as bool);
  @override
  String get watchlistMessage =>
      (super.noSuchMethod(Invocation.getter(#watchlistMessage), returnValue: '')
          as String);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i11.Future<void> fetchMovieDetail(int? id) =>
      (super.noSuchMethod(Invocation.method(#fetchMovieDetail, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i11.Future<void>);
  @override
  _i11.Future<void> addWatchlist(_i7.MovieDetail? movie) =>
      (super.noSuchMethod(Invocation.method(#addWatchlist, [movie]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i11.Future<void>);
  @override
  _i11.Future<void> removeFromWatchlist(_i7.MovieDetail? movie) =>
      (super.noSuchMethod(Invocation.method(#removeFromWatchlist, [movie]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i11.Future<void>);
  @override
  _i11.Future<void> loadWatchlistStatus(int? id) =>
      (super.noSuchMethod(Invocation.method(#loadWatchlistStatus, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i11.Future<void>);
  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}