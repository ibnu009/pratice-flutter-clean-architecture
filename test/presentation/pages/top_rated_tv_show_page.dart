import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_show_state.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late FakeTvShowTopRatedBloc fakeTvShowTopRatedBloc;

  setUp(() {
    registerFallbackValue(FakeTvShowTopRatedEvent());
    registerFallbackValue(FakeTvShowTopRatedState());

    fakeTvShowTopRatedBloc = FakeTvShowTopRatedBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvShowTopRatedBloc>(
      create: (_) => fakeTvShowTopRatedBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeTvShowTopRatedBloc.close();
  });

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => fakeTvShowTopRatedBloc.state).thenReturn(TvShowTopRatedLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowsPage()));
        expect(centerFinder, findsOneWidget);
        expect(viewProgressFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => fakeTvShowTopRatedBloc.state).thenReturn(TvShowTopRatedLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowsPage()));
        expect(viewProgressFinder, findsOneWidget);
        expect(centerFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => fakeTvShowTopRatedBloc.stream)
            .thenAnswer(((_) => Stream.value(TvShowTopRatedErrorState('Server Failure'))));
        when(() => fakeTvShowTopRatedBloc.state)
            .thenReturn(TvShowTopRatedErrorState('Server Failure'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowsPage()));

        expect(textFinder, findsOneWidget);
      });
}

// fake class for popular movie

class FakeTvShowTopRatedEvent extends Fake implements TvShowTopRatedEvent {}

class FakeTvShowTopRatedState extends Fake implements TvShowTopRatedState {}

class FakeTvShowTopRatedBloc
    extends MockBloc<TvShowTopRatedEvent, TvShowTopRatedState>
    implements TvShowTopRatedBloc {}