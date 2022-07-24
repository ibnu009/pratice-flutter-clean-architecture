import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_tv_show_bloc_test.mocks.dart';

@GenerateMocks([SearchTvShows])
void main() {
  late TvShowSearchBloc bloc;
  late MockSearchTvShows mockSearchTvShow;

  setUp(() {
    mockSearchTvShow = MockSearchTvShows();
    bloc = TvShowSearchBloc(mockSearchTvShow);
  });

  final tQuery = 'spiderman';

  group('Search TvShow Bloc Testing', () {
    test('initial state should be empty', () {
      expect(bloc.state, TvShowSearchEmptyState());
    });

    blocTest<TvShowSearchBloc, TvShowSearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchTvShow.execute(tQuery))
            .thenAnswer((_) async => Right(testTvShowList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnSearchTvShowEvent(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowSearchLoadingState(),
        TvShowSearchHasDataState(testTvShowList),
      ],
      verify: (bloc) {
        verify(mockSearchTvShow.execute(tQuery));
      },
    );

    blocTest<TvShowSearchBloc, TvShowSearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchTvShow.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnSearchTvShowEvent(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowSearchLoadingState(),
        TvShowSearchErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTvShow.execute(tQuery));
      },
    );
  });
}