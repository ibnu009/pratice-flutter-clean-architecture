import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc bloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    bloc = MovieDetailBloc(mockGetMovieDetail);
  });

  final tId = 1;

  group('Movie Detail Bloc Testing', () {

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit "Loading" and then "HasData" when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieDetail(tId)),
      expect: () => [
        MovieDetailLoadingState(),
        MovieDetailHasDataState(testMovieDetail),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        return OnGetMovieDetail(tId).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit "Loading" and then "Error" when data is failed to fetch',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnGetMovieDetail(tId)),
      expect: () => [
        MovieDetailLoadingState(),
        MovieDetailErrorState('Server Failure'),
      ],
      verify: (bloc) => MovieDetailLoadingState(),
    );
  });
}