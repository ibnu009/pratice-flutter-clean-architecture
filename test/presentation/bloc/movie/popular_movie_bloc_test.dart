import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_movie_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MoviePopularBloc bloc;
  late MockGetPopularMovies mockGetPopularMovie;

  setUp(() {
    mockGetPopularMovie = MockGetPopularMovies();
    bloc = MoviePopularBloc(mockGetPopularMovie);
  });

  group('Top Rated Movie Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, MoviePopularEmptyState());
    });

    blocTest<MoviePopularBloc, MoviePopularState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetPopularMovie.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMoviePopularEvent()),
      expect: () => [
        MoviePopularLoadingState(),
        MoviePopularHasDataState(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovie.execute());
        return OnGetMoviePopularEvent().props;
      },
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetPopularMovie.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMoviePopularEvent()),
      expect: () => [
        MoviePopularLoadingState(),
        MoviePopularErrorState('Server Failure'),
      ],
      verify: (bloc) => MoviePopularLoadingState(),
    );
  });
}