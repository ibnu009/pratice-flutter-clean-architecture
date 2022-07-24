import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv/recomendation/recomendation_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/recomendation/recomendation_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/recomendation/recomendation_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'recommendation_tv_show_bloc_test.mocks.dart';

@GenerateMocks([GetTvShowRecommendations])
void main() {
  late TvShowRecommendationBloc bloc;
  late MockGetTvShowRecommendations mockGetTvShowRecommendations;

  setUp(() {
    mockGetTvShowRecommendations = MockGetTvShowRecommendations();
    bloc = TvShowRecommendationBloc(mockGetTvShowRecommendations);
  });

  final tId = 1;

  group('TvShow Recommendations Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, TvShowRecommendationEmptyState());
    });

    blocTest<TvShowRecommendationBloc, TvShowRecommendationState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvShowList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowRecommendationEvent(tId)),
      expect: () => [
        TvShowRecommendationLoadingState(),
        TvShowRecommendationHasDataState(testTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetTvShowRecommendations.execute(tId));
        return OnGetTvShowRecommendationEvent(tId).props;
      },
    );

    blocTest<TvShowRecommendationBloc, TvShowRecommendationState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowRecommendationEvent(tId)),
      expect: () => [
        TvShowRecommendationLoadingState(),
        TvShowRecommendationErrorState('Server Failure'),
      ],
      verify: (bloc) => TvShowRecommendationLoadingState(),
    );
  });
}