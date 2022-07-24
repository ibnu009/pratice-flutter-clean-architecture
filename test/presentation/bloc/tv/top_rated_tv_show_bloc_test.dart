import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_show_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvShows])
void main() {
  late TvShowTopRatedBloc bloc;
  late MockGetTopRatedTvShows mockGetTopRatedTvShow;

  setUp(() {
    mockGetTopRatedTvShow = MockGetTopRatedTvShows();
    bloc = TvShowTopRatedBloc(mockGetTopRatedTvShow);
  });

  group('Top Rated TvShow Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, TvShowTopRatedEmptyState());
    });

    blocTest<TvShowTopRatedBloc, TvShowTopRatedState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetTopRatedTvShow.execute())
            .thenAnswer((_) async => Right(testTvShowList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowTopRatedEvent()),
      expect: () => [
        TvShowTopRatedLoadingState(),
        TvShowTopRatedHasDataState(testTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvShow.execute());
        return OnGetTvShowTopRatedEvent().props;
      },
    );

    blocTest<TvShowTopRatedBloc, TvShowTopRatedState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetTopRatedTvShow.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowTopRatedEvent()),
      expect: () => [
        TvShowTopRatedLoadingState(),
        TvShowTopRatedErrorState('Server Failure'),
      ],
      verify: (bloc) => TvShowTopRatedLoadingState(),
    );
  });
}