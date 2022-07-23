import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_movie_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovie;

  setUp(() {
    mockSearchMovie = MockSearchMovies();
    bloc = MovieSearchBloc(mockSearchMovie);
  });

  final tQuery = 'spiderman';

  group('Search Movie Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, MovieSearchEmptyState());
    });

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchMovie.execute(tQuery))
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnSearchMovieEvent(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieSearchLoadingState(),
        MovieSearchHasDataState(testMovieList),
      ],
      verify: (bloc) {
        verify(mockSearchMovie.execute(tQuery));
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchMovie.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnSearchMovieEvent(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieSearchLoadingState(),
        MovieSearchErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchMovie.execute(tQuery));
      },
    );
  });
}