import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_movie_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MovieTopRatedBloc bloc;
  late MockGetTopRatedMovies mockGetTopRatedMovie;

  setUp(() {
    mockGetTopRatedMovie = MockGetTopRatedMovies();
    bloc = MovieTopRatedBloc(mockGetTopRatedMovie);
  });

  group('Top Rated Movie Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, MovieTopRatedEmptyState());
    });

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetTopRatedMovie.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieTopRatedEvent()),
      expect: () => [
        MovieTopRatedLoadingState(),
        MovieTopRatedHasDataState(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovie.execute());
        return OnGetMovieTopRatedEvent().props;
      },
    );

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetTopRatedMovie.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieTopRatedEvent()),
      expect: () => [
        MovieTopRatedLoadingState(),
        MovieTopRatedErrorState('Server Failure'),
      ],
      verify: (bloc) => MovieTopRatedLoadingState(),
    );
  });
}