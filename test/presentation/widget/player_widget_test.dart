import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cenoyam/domain/entity/track.dart';
import 'package:cenoyam/domain/enum/player_state.dart';
import 'package:cenoyam/presentation/bloc/duration_state.dart';
import 'package:cenoyam/presentation/bloc/player_bloc.dart';
import 'package:cenoyam/presentation/bloc/player_event.dart';
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
  StreamController<DurationState>? durationStateController;
  setUp(() {
    bloc = MockPlayerBloc();
    stateController = StreamController<PlayerState>();
    currentTrackController = StreamController<TrackMin?>();
    durationController = StreamController<Duration>();
    positionController = StreamController<Duration>();
    progressController = StreamController<double>();
    durationStateController = StreamController<DurationState>();
    when(bloc!.state).thenAnswer((_) => stateController!.stream);
    when(bloc!.currentTrack).thenAnswer((_) => currentTrackController!.stream);
    when(bloc!.duration).thenAnswer((_) => durationController!.stream);
    when(bloc!.position).thenAnswer((_) => positionController!.stream);
    when(bloc!.progress).thenAnswer((_) => progressController!.stream);
    when(bloc!.durationState)
        .thenAnswer((_) => durationStateController!.stream);
  });
  tearDown(() {
    bloc = null;
    stateController?.close();
    currentTrackController?.close();
    durationController?.close();
    positionController?.close();
    progressController?.close();
    durationStateController?.close();
    stateController = null;
    currentTrackController = null;
    durationController = null;
    positionController = null;
    progressController = null;
    durationStateController = null;
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

      await widgetTester.tap(button, warnIfMissed: false);

      verifyNever(bloc!.command);
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

      final progressBar = find.byType(ProgressBar);
      expect(progressBar, findsOneWidget);
      expect(
        widgetTester.widget<ProgressBar>(progressBar).progress,
        Duration.zero,
      );
    });
  });

  group('When playing', () {
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
      durationStateController!.sink.add(
        const DurationState(Duration(seconds: 30), Duration(seconds: 60)),
      );
    });

    testWidgets('button pauses player', (widgetTester) async {
      final commandController = StreamController<PlayerEvent>();
      when(bloc!.command).thenReturn(commandController.sink);
      addTearDown(commandController.close);
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

      await widgetTester.tap(button);

      expect(commandController.stream, emits(const PlayerEvent.pause()));
    });

    testWidgets('progress bar shows progress', (widgetTester) async {
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

      final progressBar = find.byType(ProgressBar);
      expect(progressBar, findsOneWidget);
      expect(
        widgetTester.widget<ProgressBar>(progressBar).progress,
        const Duration(seconds: 30),
      );
      expect(
        widgetTester.widget<ProgressBar>(progressBar).total,
        const Duration(seconds: 60),
      );
    });

    testWidgets('duration and position are shown', skip: true,
        (widgetTester) async {
      await widgetTester.pumpWidget(
        Provider<PlayerBloc>.value(
          value: bloc!,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PlayerWidget(),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final duration = find.textContaining('0:30');
      final position = find.textContaining('1:00');

      expect(duration, findsOneWidget);
      expect(position, findsOneWidget);
    });

    testWidgets('track and artist are shown', (widgetTester) async {
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

      final track = find.textContaining('Track 1');
      final artist = find.textContaining('Artist 1');

      expect(track, findsOneWidget);
      expect(artist, findsOneWidget);
    });

    group('and paused', () {
      setUp(() {
        stateController!.sink.add(PlayerState.paused);
      });

      testWidgets('button resumes player', (widgetTester) async {
        final commandController = StreamController<PlayerEvent>();
        when(bloc!.command).thenReturn(commandController.sink);
        addTearDown(commandController.close);
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

        final button = find.widgetWithText(TextButton, '|>');

        expect(button, findsOneWidget);
        expect(widgetTester.widget<TextButton>(button).enabled, true);

        await widgetTester.tap(button);

        expect(commandController.stream, emits(const PlayerEvent.resume()));
      });
    });

    group('and completed', () {
      setUp(() {
        stateController!.sink.add(PlayerState.stopped);
      });

      testWidgets('button is in play state', (widgetTester) async {
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

        final button = find.widgetWithText(TextButton, '|>');

        expect(button, findsOneWidget);
        expect(widgetTester.widget<TextButton>(button).enabled, false);

        await widgetTester.tap(button, warnIfMissed: false);

        verifyNever(bloc!.command);
      });
    });
  });
}
