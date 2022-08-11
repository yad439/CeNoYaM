import 'dart:async';

import 'package:cenoyam/domain/entity/track.dart';
import 'package:cenoyam/domain/enum/player_state.dart';
import 'package:cenoyam/presentation/bloc/player_bloc.dart';
import 'package:cenoyam/presentation/widget/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

@GenerateMocks([PlayerBloc])
import 'player_widget_test.mocks.dart';

void main() {
  MockPlayerBloc? bloc;
  StreamController<PlayerState>? stateController;
  StreamController<TrackMin?>? currentTrackController;
  StreamController<Duration>? durationController;
  StreamController<Duration>? positionController;
  StreamController<double>? progressController;
  setUp(() {
    bloc = MockPlayerBloc();
    stateController = StreamController<PlayerState>();
    currentTrackController = StreamController<TrackMin?>();
    durationController = StreamController<Duration>();
    positionController = StreamController<Duration>();
    progressController = StreamController<double>();
    when(bloc!.state).thenAnswer((_) => stateController!.stream);
    when(bloc!.currentTrack).thenAnswer((_) => currentTrackController!.stream);
    when(bloc!.duration).thenAnswer((_) => durationController!.stream);
    when(bloc!.position).thenAnswer((_) => positionController!.stream);
    when(bloc!.progress).thenAnswer((_) => progressController!.stream);
  });
  tearDown(() {
    bloc = null;
    stateController?.close();
    currentTrackController?.close();
    durationController?.close();
    positionController?.close();
    progressController?.close();
    stateController = null;
    currentTrackController = null;
    durationController = null;
    positionController = null;
    progressController = null;
  });
  group('Initially', () {
    testWidgets('play button is disabled', (widgetTester) async {
      await widgetTester.pumpWidget(
        Provider<PlayerBloc>.value(
          value: bloc!,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PlayerWidget(),
          ),
        ),
      );

      final button = find.widgetWithText(TextButton, '|>');

      expect(button, findsOneWidget);
      expect(widgetTester.widget<TextButton>(button).enabled, false);
    });
    testWidgets('no track name showed', (widgetTester) async {
      await widgetTester.pumpWidget(
        Provider<PlayerBloc>.value(
          value: bloc!,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PlayerWidget(),
          ),
        ),
      );

      expect(find.text('-'), findsOneWidget);
    });
    testWidgets('progress is empty', (widgetTester) async {
      await widgetTester.pumpWidget(
        Provider<PlayerBloc>.value(
          value: bloc!,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PlayerWidget(),
          ),
        ),
      );

      final progressBar = find.byType(LinearProgressIndicator);
      expect(progressBar, findsOneWidget);
      expect(
        widgetTester.widget<LinearProgressIndicator>(progressBar).value,
        0,
      );
    });
    testWidgets('duration and position are zeros', (widgetTester) async {
      await widgetTester.pumpWidget(
        Provider<PlayerBloc>.value(
          value: bloc!,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PlayerWidget(),
          ),
        ),
      );

      final duration = find.text(Duration.zero.toString());
      expect(duration, findsNWidgets(2));
    });
  });
  group('When start playing', () {
    setUp(() {
      stateController!.sink.add(PlayerState.playing);
      currentTrackController!.sink.add(
        const TrackMin(
          1,
          'Track 1',
          true,
          'Artist 1',
        ),
      );
      durationController!.sink.add(const Duration(seconds: 60));
      positionController!.sink.add(const Duration(seconds: 30));
      progressController!.sink.add(0.5);
    });

    testWidgets('button in pause state', (widgetTester) async {
      await widgetTester.pumpWidget(
        Provider<PlayerBloc>.value(
          value: bloc!,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PlayerWidget(),
          ),
        ),
      );
      await widgetTester.pump();

      final button = find.widgetWithText(TextButton, '||');

      expect(button, findsOneWidget);
      expect(widgetTester.widget<TextButton>(button).enabled, true);
    });
  });
}
