import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation/recomendation_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'recommendation_movie_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationBloc bloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    bloc = MovieRecommendationBloc(mockGetMovieRecommendations);
  });

  final tId = 1;

  group('Movie Recommendations Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, MovieRecommendationEmptyState());
    });

    blocTest<MovieRecommendationBloc, MovieRecommendationState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieRecommendationEvent(tId)),
      expect: () => [
        MovieRecommendationLoadingState(),
        MovieRecommendationHasDataState(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
        return OnGetMovieRecommendationEvent(tId).props;
      },
    );

    blocTest<MovieRecommendationBloc, MovieRecommendationState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieRecommendationEvent(tId)),
      expect: () => [
        MovieRecommendationLoadingState(),
        MovieRecommendationErrorState('Server Failure'),
      ],
      verify: (bloc) => MovieRecommendationLoadingState(),
    );
  });
}