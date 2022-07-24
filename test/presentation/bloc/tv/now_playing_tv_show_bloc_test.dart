import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_show.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing/now_playing_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing/now_playing_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing/now_playing_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_show_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvShows])
void main() {
  late TvShowNowPlayingBloc bloc;
  late MockGetNowPlayingTvShows mockGetNowPlayingTvShow;

  setUp(() {
    mockGetNowPlayingTvShow = MockGetNowPlayingTvShows();
    bloc = TvShowNowPlayingBloc(mockGetNowPlayingTvShow);
  });

  group('Top Rated TvShow Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, TvShowNowPlayingEmptyState());
    });

    blocTest<TvShowNowPlayingBloc, TvShowNowPlayingState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetNowPlayingTvShow.execute())
            .thenAnswer((_) async => Right(testTvShowList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowNowPlayingEvent()),
      expect: () => [
        TvShowNowPlayingLoadingState(),
        TvShowNowPlayingHasDataState(testTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvShow.execute());
        return OnGetTvShowNowPlayingEvent().props;
      },
    );

    blocTest<TvShowNowPlayingBloc, TvShowNowPlayingState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetNowPlayingTvShow.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowNowPlayingEvent()),
      expect: () => [
        TvShowNowPlayingLoadingState(),
        TvShowNowPlayingErrorState('Server Failure'),
      ],
      verify: (bloc) => TvShowNowPlayingLoadingState(),
    );
  });
}