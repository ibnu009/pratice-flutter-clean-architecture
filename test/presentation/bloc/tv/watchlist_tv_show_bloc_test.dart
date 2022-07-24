import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_show_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvShows,
  GetWatchListTvShowStatus,
  SaveTvShowWatchlist,
  RemoveTvShowWatchlist,
])
void main() {
  late TvShowWatchListBloc bloc;
  late GetWatchlistTvShows mockGetWatchlistTvShow;
  late GetWatchListTvShowStatus mockGetWatchlistTvShowStatus;
  late SaveTvShowWatchlist mockSaveWatchlistTvShow;
  late RemoveTvShowWatchlist mockRemoveWatchlistTvShow;

  setUp(() {
    mockGetWatchlistTvShow = MockGetWatchlistTvShows();
    mockGetWatchlistTvShowStatus = MockGetWatchListTvShowStatus();
    mockSaveWatchlistTvShow = MockSaveTvShowWatchlist();
    mockRemoveWatchlistTvShow = MockRemoveTvShowWatchlist();
    bloc = TvShowWatchListBloc(
      mockGetWatchlistTvShow,
      mockGetWatchlistTvShowStatus,
      mockRemoveWatchlistTvShow,
      mockSaveWatchlistTvShow,
    );
  });

  final tId = 1;

  group('Watchlist TvShow Bloc Testing', () {

    blocTest<TvShowWatchListBloc, TvShowWatchListState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetWatchlistTvShow.execute())
            .thenAnswer((_) async => Right(testTvShowList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowWatchList()),
      expect: () => [
        TvShowWatchListLoadingState(),
        TvShowWatchListHasDataState(testTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvShow.execute());
        return OnGetTvShowWatchList().props;
      },
    );

    blocTest<TvShowWatchListBloc, TvShowWatchListState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch'
      ,
      build: () {
        when(mockGetWatchlistTvShow.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowWatchList()),
      expect: () => [
        TvShowWatchListLoadingState(),
        TvShowWatchListErrorState('Server Failure'),
      ],
      verify: (bloc) => TvShowWatchListLoadingState(),
    );
  });

  group('TvShow Watchlist Status Bloc Testing', () {
    blocTest<TvShowWatchListBloc, TvShowWatchListState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetWatchlistTvShowStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(TvShowWatchListStatus(tId)),
      expect: () => [TvShowWatchListIsAddedState(true)],
      verify: (bloc) {
        verify(mockGetWatchlistTvShowStatus.execute(tId));
        return TvShowWatchListStatus(tId).props;
      },
    );

    blocTest<TvShowWatchListBloc, TvShowWatchListState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetWatchlistTvShowStatus.execute(tId))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(TvShowWatchListStatus(tId)),
      expect: () => [TvShowWatchListIsAddedState(false)],
      verify: (bloc) => TvShowWatchListLoadingState(),
    );
  });

  group('Add Watchlist TvShow Bloc Testing', () {
    blocTest<TvShowWatchListBloc, TvShowWatchListState>(
      'Should emit message "Added to Watchlist TvShow" when added',
      build: () {
        when(mockSaveWatchlistTvShow.execute(testTvShowDetail))
            .thenAnswer((_) async => Right('Added to Watchlist TvShow'));
        return bloc;
      },
      act: (bloc) => bloc.add(TvShowWatchListAdd(testTvShowDetail)),
      expect: () => [
        TvShowWatchListMessage('Added to Watchlist TvShow'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTvShow.execute(testTvShowDetail));
        return TvShowWatchListAdd(testTvShowDetail).props;
      },
    );

    blocTest<TvShowWatchListBloc, TvShowWatchListState>(
      'Should emit message "Added to Watchlist Fail" when error is occurred',
      build: () {
        when(mockSaveWatchlistTvShow.execute(testTvShowDetail)).thenAnswer(
                (_) async => Left(DatabaseFailure('Added to Watchlist Fail')));
        return bloc;
      },
      act: (bloc) => bloc.add(TvShowWatchListAdd(testTvShowDetail)),
      expect: () => [
        TvShowWatchListErrorState('Added to Watchlist Fail'),
      ],
      verify: (bloc) => TvShowWatchListAdd(testTvShowDetail),
    );
  });

  group('Removed Watchlist TvShow Bloc Testing', () {
    blocTest<TvShowWatchListBloc, TvShowWatchListState>(
      'Should emit "Success" when movie is gotten removed from watchList',
      build: () {
        when(mockRemoveWatchlistTvShow.execute(testTvShowDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist TvShow'));
        return bloc;
      },
      act: (bloc) => bloc.add(TvShowWatchListRemove(testTvShowDetail)),
      expect: () => [
        TvShowWatchListMessage('Removed from Watchlist TvShow'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTvShow.execute(testTvShowDetail));
        return TvShowWatchListRemove(testTvShowDetail).props;
      },
    );

    blocTest<TvShowWatchListBloc, TvShowWatchListState>(
      'Should emit "Error" when movie is gotten removed from watchList',
      build: () {
        when(mockRemoveWatchlistTvShow.execute(testTvShowDetail)).thenAnswer(
                (_) async => Left(DatabaseFailure('Removed from Watchlist Fail')));
        return bloc;
      },
      act: (bloc) => bloc.add(TvShowWatchListRemove(testTvShowDetail)),
      expect: () => [
        TvShowWatchListErrorState('Removed from Watchlist Fail'),
      ],
      verify: (bloc) => TvShowWatchListRemove(testTvShowDetail),
    );
  });
}