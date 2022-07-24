import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_state.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late FakeMoviePopularBloc fakeMoviePopularBloc;

  setUp(() {
    registerFallbackValue(FakeMoviePopularEvent());
    registerFallbackValue(FakeMoviePopularState());

    fakeMoviePopularBloc = FakeMoviePopularBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MoviePopularBloc>(
      create: (_) => fakeMoviePopularBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeMoviePopularBloc.close();
  });

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => fakeMoviePopularBloc.state).thenReturn(MoviePopularLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));
        expect(centerFinder, findsOneWidget);
        expect(viewProgressFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => fakeMoviePopularBloc.state).thenReturn(MoviePopularLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));
        expect(viewProgressFinder, findsOneWidget);
        expect(centerFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => fakeMoviePopularBloc.stream)
            .thenAnswer(((_) => Stream.value(MoviePopularErrorState('Server Failure'))));
        when(() => fakeMoviePopularBloc.state)
            .thenReturn(MoviePopularErrorState('Server Failure'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

        expect(textFinder, findsOneWidget);
      });
}

// fake class for popular movie

class FakeMoviePopularEvent extends Fake implements MoviePopularEvent {}

class FakeMoviePopularState extends Fake implements MoviePopularState {}

class FakeMoviePopularBloc
    extends MockBloc<MoviePopularEvent, MoviePopularState>
    implements MoviePopularBloc {}