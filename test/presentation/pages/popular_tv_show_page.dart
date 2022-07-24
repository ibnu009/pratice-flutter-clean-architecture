import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_show_state.dart';
import 'package:ditonton/presentation/pages/popular_tv_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late FakeTvShowPopularBloc fakeTvShowPopularBloc;

  setUp(() {
    registerFallbackValue(FakeTvShowPopularEvent());
    registerFallbackValue(FakeTvShowPopularState());

    fakeTvShowPopularBloc = FakeTvShowPopularBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvShowPopularBloc>(
      create: (_) => fakeTvShowPopularBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeTvShowPopularBloc.close();
  });

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => fakeTvShowPopularBloc.state).thenReturn(TvShowPopularLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularTvShowsPage()));
        expect(centerFinder, findsOneWidget);
        expect(viewProgressFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => fakeTvShowPopularBloc.state).thenReturn(TvShowPopularLoadingState());

        final viewProgressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularTvShowsPage()));
        expect(viewProgressFinder, findsOneWidget);
        expect(centerFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => fakeTvShowPopularBloc.stream)
            .thenAnswer(((_) => Stream.value(TvShowPopularErrorState('Server Failure'))));
        when(() => fakeTvShowPopularBloc.state)
            .thenReturn(TvShowPopularErrorState('Server Failure'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(PopularTvShowsPage()));

        expect(textFinder, findsOneWidget);
      });
}

// fake class for popular movie

class FakeTvShowPopularEvent extends Fake implements TvShowPopularEvent {}

class FakeTvShowPopularState extends Fake implements TvShowPopularState {}

class FakeTvShowPopularBloc
    extends MockBloc<TvShowPopularEvent, TvShowPopularState>
    implements TvShowPopularBloc {}