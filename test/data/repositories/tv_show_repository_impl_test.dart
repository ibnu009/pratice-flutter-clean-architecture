import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_show_detail_model.dart';
import 'package:ditonton/data/models/tv_show_model.dart';
import 'package:ditonton/data/repositories/tv_show_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvShowRepositoryImpl repository;
  late MockTvShowRemoteDataSource mockRemoteDataSource;
  late MockTvShowLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvShowRemoteDataSource();
    mockLocalDataSource = MockTvShowLocalDataSource();
    repository = TvShowRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvShowModel = TvShowModel(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Anoman',
    overview:
    'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Anoman.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Anoman',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvShow = TvShow(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Anoman',
    overview:
    'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Anoman.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Anoman',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvShowModelList = <TvShowModel>[tTvShowModel];
  final tTvShowList = <TvShow>[tTvShow];

  group('Now Playing TvShows', () {
    test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTvShows())
              .thenAnswer((_) async => tTvShowModelList);
          // act
          final result = await repository.getNowPlayingTvShows();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvShows());
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvShowList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTvShows())
              .thenThrow(ServerException());
          // act
          final result = await repository.getNowPlayingTvShows();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvShows());
          expect(result, equals(Left(ServerFailure('Server Error'))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTvShows())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getNowPlayingTvShows();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvShows());
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Popular TvShows', () {
    test('should return movie list when call to data source is success',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvShows())
              .thenAnswer((_) async => tTvShowModelList);
          // act
          final result = await repository.getPopularTvShows();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvShowList);
        });

    test(
        'should return server failure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvShows())
              .thenThrow(ServerException());
          // act
          final result = await repository.getPopularTvShows();
          // assert
          expect(result, Left(ServerFailure('Server Error')));
        });

    test(
        'should return connection failure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvShows())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getPopularTvShows();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Top Rated TvShows', () {
    test('should return movie list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvShows())
              .thenAnswer((_) async => tTvShowModelList);
          // act
          final result = await repository.getTopRatedTvShows();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvShowList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvShows())
              .thenThrow(ServerException());
          // act
          final result = await repository.getTopRatedTvShows();
          // assert
          expect(result, Left(ServerFailure('Server Error')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvShows())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTopRatedTvShows();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Get TvShow Detail', () {
    final tId = 1;
    final tTvShowResponse = TvShowDetailResponse(
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      voteAverage: 1,
      voteCount: 1,
      numberOfSeasons: 2,
      inProduction: false,
      numberOfEpisodes: 12,
    );

    test(
        'should return TvShow data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvShowDetail(tId))
              .thenAnswer((_) async => tTvShowResponse);
          // act
          final result = await repository.getTvShowDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvShowDetail(tId));
          expect(result, equals(Right(testTvShowDetail)));
        });

    test(
        'should return Server Error when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvShowDetail(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvShowDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvShowDetail(tId));
          expect(result, equals(Left(ServerFailure('Server Error'))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvShowDetail(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvShowDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvShowDetail(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get TvShow Recommendations', () {
    final tTvShowList = <TvShowModel>[];
    final tId = 1;

    test('should return data (movie list) when the call is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvShowRecommendations(tId))
              .thenAnswer((_) async => tTvShowList);
          // act
          final result = await repository.getTvShowRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTvShowRecommendations(tId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tTvShowList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvShowRecommendations(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvShowRecommendations(tId);
          // assertbuild runner
          verify(mockRemoteDataSource.getTvShowRecommendations(tId));
          expect(result, equals(Left(ServerFailure('Server Error'))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvShowRecommendations(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvShowRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTvShowRecommendations(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Seach TvShows', () {
    final tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvShows(tQuery))
              .thenAnswer((_) async => tTvShowModelList);
          // act
          final result = await repository.searchTvShows(tQuery);
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvShowList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvShows(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchTvShows(tQuery);
          // assert
          expect(result, Left(ServerFailure('Server Error')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvShows(tQuery))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchTvShows(tQuery);
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTvShowById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of TvShows', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTvShows())
          .thenAnswer((_) async => [testTvShowTable]);
      // act
      final result = await repository.getWatchlistTvShows();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvShow]);
    });
  });
}