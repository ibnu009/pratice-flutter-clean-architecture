import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieWatchListBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovie;
  late MockGetWatchListStatus mockGetWatchlistMovieStatus;
  late MockSaveWatchlist mockSaveWatchlistMovie;
  late MockRemoveWatchlist mockRemoveWatchlistMovie;

  setUp(() {
    mockGetWatchlistMovie = MockGetWatchlistMovies();
    mockGetWatchlistMovieStatus = MockGetWatchListStatus();
    mockSaveWatchlistMovie = MockSaveWatchlist();
    mockRemoveWatchlistMovie = MockRemoveWatchlist();
    bloc = MovieWatchListBloc(
      mockGetWatchlistMovie,
      mockGetWatchlistMovieStatus,
      mockRemoveWatchlistMovie,
      mockSaveWatchlistMovie,
    );
  });

  final tId = 1;

  group('Watchlist Movie Bloc Testing', () {

    blocTest<MovieWatchListBloc, MovieWatchListState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetWatchlistMovie.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieWatchList()),
      expect: () => [
        MovieWatchListLoadingState(),
        MovieWatchListHasDataState(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovie.execute());
        return OnGetMovieWatchList().props;
      },
    );

    blocTest<MovieWatchListBloc, MovieWatchListState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch'
      ,
      build: () {
        when(mockGetWatchlistMovie.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieWatchList()),
      expect: () => [
        MovieWatchListLoadingState(),
        MovieWatchListErrorState('Server Failure'),
      ],
      verify: (bloc) => MovieWatchListLoadingState(),
    );
  });

  group('Movie Watchlist Status Bloc Testing', () {
    blocTest<MovieWatchListBloc, MovieWatchListState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetWatchlistMovieStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(MovieWatchListStatus(tId)),
      expect: () => [MovieWatchListIsAddedState(true)],
      verify: (bloc) {
        verify(mockGetWatchlistMovieStatus.execute(tId));
        return MovieWatchListStatus(tId).props;
      },
    );

    blocTest<MovieWatchListBloc, MovieWatchListState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetWatchlistMovieStatus.execute(tId))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(MovieWatchListStatus(tId)),
      expect: () => [MovieWatchListIsAddedState(false)],
      verify: (bloc) => MovieWatchListLoadingState(),
    );
  });

  group('Add Watchlist Movie Bloc Testing', () {
    blocTest<MovieWatchListBloc, MovieWatchListState>(
      'Should emit message "Added to Watchlist Movie" when added',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist Movie'));
        return bloc;
      },
      act: (bloc) => bloc.add(MovieWatchListAdd(testMovieDetail)),
      expect: () => [
        MovieWatchListMessage('Added to Watchlist Movie'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        return MovieWatchListAdd(testMovieDetail).props;
      },
    );

    blocTest<MovieWatchListBloc, MovieWatchListState>(
      'Should emit message "Added to Watchlist Fail" when error is occurred',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail)).thenAnswer(
                (_) async => Left(DatabaseFailure('Added to Watchlist Fail')));
        return bloc;
      },
      act: (bloc) => bloc.add(MovieWatchListAdd(testMovieDetail)),
      expect: () => [
        MovieWatchListErrorState('Added to Watchlist Fail'),
      ],
      verify: (bloc) => MovieWatchListAdd(testMovieDetail),
    );
  });

  group('Removed Watchlist Movie Bloc Testing', () {
    blocTest<MovieWatchListBloc, MovieWatchListState>(
      'Should emit "Success" when movie is gotten removed from watchList',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist Movie'));
        return bloc;
      },
      act: (bloc) => bloc.add(MovieWatchListRemove(testMovieDetail)),
      expect: () => [
        MovieWatchListMessage('Removed from Watchlist Movie'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        return MovieWatchListRemove(testMovieDetail).props;
      },
    );

    blocTest<MovieWatchListBloc, MovieWatchListState>(
      'Should emit "Error" when movie is gotten removed from watchList',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail)).thenAnswer(
                (_) async => Left(DatabaseFailure('Removed from Watchlist Fail')));
        return bloc;
      },
      act: (bloc) => bloc.add(MovieWatchListRemove(testMovieDetail)),
      expect: () => [
        MovieWatchListErrorState('Removed from Watchlist Fail'),
      ],
      verify: (bloc) => MovieWatchListRemove(testMovieDetail),
    );
  });
}