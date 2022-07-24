import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_tv_show_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvShows])
void main() {
  late TvShowPopularBloc bloc;
  late MockGetPopularTvShows mockGetPopularTvShow;

  setUp(() {
    mockGetPopularTvShow = MockGetPopularTvShows();
    bloc = TvShowPopularBloc(mockGetPopularTvShow);
  });

  group('Top Rated TvShow Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, TvShowPopularEmptyState());
    });

    blocTest<TvShowPopularBloc, TvShowPopularState>(
      'Should emit "Loading" and then "HasData" when data is fetched',
      build: () {
        when(mockGetPopularTvShow.execute())
            .thenAnswer((_) async => Right(testTvShowList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowPopularEvent()),
      expect: () => [
        TvShowPopularLoadingState(),
        TvShowPopularHasDataState(testTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvShow.execute());
        return OnGetTvShowPopularEvent().props;
      },
    );

    blocTest<TvShowPopularBloc, TvShowPopularState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetPopularTvShow.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowPopularEvent()),
      expect: () => [
        TvShowPopularLoadingState(),
        TvShowPopularErrorState('Server Failure'),
      ],
      verify: (bloc) => TvShowPopularLoadingState(),
    );
  });
}