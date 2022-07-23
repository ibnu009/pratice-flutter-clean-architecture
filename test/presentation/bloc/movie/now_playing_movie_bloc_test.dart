import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movie_state.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MovieNowPlayingBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovie;

  setUp(() {
    mockGetNowPlayingMovie = MockGetNowPlayingMovies();
    bloc = MovieNowPlayingBloc(mockGetNowPlayingMovie);
  });

  group('Top Rated Movie Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, MovieNowPlayingEmptyState());
    });

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetNowPlayingMovie.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieNowPlayingEvent()),
      expect: () => [
        MovieNowPlayingLoadingState(),
        MovieNowPlayingHasDataState(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovie.execute());
        return OnGetMovieNowPlayingEvent().props;
      },
    );

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetNowPlayingMovie.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieNowPlayingEvent()),
      expect: () => [
        MovieNowPlayingLoadingState(),
        MovieNowPlayingErrorState('Server Failure'),
      ],
      verify: (bloc) => MovieNowPlayingLoadingState(),
    );
  });
}