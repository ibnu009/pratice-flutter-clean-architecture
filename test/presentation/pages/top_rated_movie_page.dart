import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_state.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late FakeMovieTopRatedBloc fakeMovieTopRatedBloc;

  setUp(() {
    registerFallbackValue(FakeMovieTopRatedEvent());
    registerFallbackValue(FakeMovieTopRatedState());

    fakeMovieTopRatedBloc = FakeMovieTopRatedBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieTopRatedBloc>(
      create: (_) => fakeMovieTopRatedBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeMovieTopRatedBloc.close();
  });

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => fakeMovieTopRatedBloc.state).thenReturn(MovieTopRatedLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
        expect(centerFinder, findsOneWidget);
        expect(viewProgressFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => fakeMovieTopRatedBloc.state).thenReturn(MovieTopRatedLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
        expect(viewProgressFinder, findsOneWidget);
        expect(centerFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => fakeMovieTopRatedBloc.stream)
            .thenAnswer(((_) => Stream.value(MovieTopRatedErrorState('Server Failure'))));
        when(() => fakeMovieTopRatedBloc.state)
            .thenReturn(MovieTopRatedErrorState('Server Failure'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

        expect(textFinder, findsOneWidget);
      });
}

// fake class for popular movie

class FakeMovieTopRatedEvent extends Fake implements MovieTopRatedEvent {}

class FakeMovieTopRatedState extends Fake implements MovieTopRatedState {}

class FakeMovieTopRatedBloc
    extends MockBloc<MovieTopRatedEvent, MovieTopRatedState>
    implements MovieTopRatedBloc {}