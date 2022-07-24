import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_state.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late FakeMovieWatchListBloc fakeMovieWatchListBloc;

  setUp(() {
    registerFallbackValue(FakeMovieWatchListEvent());
    registerFallbackValue(FakeMovieWatchListState());

    fakeMovieWatchListBloc = FakeMovieWatchListBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieWatchListBloc>(
      create: (_) => fakeMovieWatchListBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeMovieWatchListBloc.close();
  });

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => fakeMovieWatchListBloc.state).thenReturn(MovieWatchListLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
        expect(centerFinder, findsOneWidget);
        expect(viewProgressFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => fakeMovieWatchListBloc.state).thenReturn(MovieWatchListLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
        expect(viewProgressFinder, findsOneWidget);
        expect(centerFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => fakeMovieWatchListBloc.stream)
            .thenAnswer(((_) => Stream.value(MovieWatchListErrorState('Server Failure'))));
        when(() => fakeMovieWatchListBloc.state)
            .thenReturn(MovieWatchListErrorState('Server Failure'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));

        expect(textFinder, findsOneWidget);
      });
}

// fake class for popular movie

class FakeMovieWatchListEvent extends Fake implements MovieWatchListEvent {}

class FakeMovieWatchListState extends Fake implements MovieWatchListState {}

class FakeMovieWatchListBloc
    extends MockBloc<MovieWatchListEvent, MovieWatchListState>
    implements MovieWatchListBloc {}