import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv/detail/detail_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/detail/detail_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/detail/detail_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_tv_show_bloc_test.mocks.dart';

@GenerateMocks([GetTvShowDetail])
void main() {
  late MockGetTvShowDetail mockGetTvShowDetail;
  late TvShowDetailBloc bloc;

  setUp(() {
    mockGetTvShowDetail = MockGetTvShowDetail();
    bloc = TvShowDetailBloc(mockGetTvShowDetail);
  });

  final tId = 1;

  group('TvShow Detail Bloc Testing', () {

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'Should emit "Loading" and then "HasData" when data is gotten successfully',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvShowDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowDetail(tId)),
      expect: () => [
        TvShowDetailLoadingState(),
        TvShowDetailHasDataState(testTvShowDetail),
      ],
      verify: (bloc) {
        verify(mockGetTvShowDetail.execute(tId));
        return OnGetTvShowDetail(tId).props;
      },
    );

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetTvShowDetail(tId)),
      expect: () => [
        TvShowDetailLoadingState(),
        TvShowDetailErrorState('Server Failure'),
      ],
      verify: (bloc) => TvShowDetailLoadingState(),
    );
  });
}