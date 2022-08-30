import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cenoyam/app.dart';
import 'package:cenoyam/data/json_mapper.dart';
import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:cenoyam/data/yandex_music_repository.dart';
import 'package:cenoyam/domain/music_repository.dart';
import 'package:cenoyam/domain/yandex_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../data/test_data.dart';

void main() {
  final data = TestData();
  FakePlayer? player;
  final repository =
      YandexMusicRepository(YandexMusicDatasource(data.dio), JsonMapper());
  final getIt = GetIt.asNewInstance();

  setUp(() {
    player = FakePlayer();
    getIt
      ..registerSingleton(YandexPlayer(player!, repository))
      ..registerSingleton<MusicRepository>(repository);
  });
  tearDown(() async {
    await getIt.reset();
    await player!.dispose();
    player = null;
  });

  testWidgets('Plays track', (tester) async {
    await tester.pumpWidget(Cenoyam(getIt));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'query');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    final track = find.text(data.trackEntity.title);
    expect(track, findsOneWidget);
    await tester.tap(track);
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );

    final play = find.widgetWithText(ElevatedButton, 'Play');
    expect(play, findsOneWidget);
    await tester.tap(play);
    await tester.pump();

    expect(player!.state, PlayerState.playing);
    expect(
      find.text(
        '${data.trackEntity.artistString} - ${data.trackEntity.title}',
      ),
      findsOneWidget,
    );
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );
    expect(find.textContaining('1:40'), findsOneWidget);
    expect(find.textContaining('0:00'), findsWidgets);

    player!.tick();
    await tester.pump();
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.5,
    );
    expect(find.textContaining('1:40'), findsOneWidget);
    expect(find.textContaining('0:50'), findsOneWidget);

    await tester.tap(find.text('||'));
    await tester.pump();

    expect(player!.state, PlayerState.paused);

    await tester.tap(find.text('|>'));
    await tester.pump();
    expect(player!.state, PlayerState.playing);

    player!.tick();
    await tester.pump();

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1,
    );
    expect(find.textContaining('1:40'), findsNWidgets(2));

    player!.tick();
    await tester.pump();

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );
  });
  testWidgets('Plays from album', (tester) async {
    await tester.pumpWidget(Cenoyam(getIt));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'query');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    final album = find.text(data.albumEntity.title);
    expect(album, findsOneWidget);
    await tester.tap(album);
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '|>').first);
    await tester.pump();
    expect(player!.state, PlayerState.playing);
    expect(find.textContaining('1:40'), findsOneWidget);
    expect(find.textContaining('0:00'), findsWidgets);
  });

  testWidgets('Plays from playlist', (tester) async {
    await tester.pumpWidget(Cenoyam(getIt));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'query');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text(data.playlistEntity.title),
      find.byType(CustomScrollView),
      const Offset(0, -100),
    );
    final playlist = find.text(data.playlistEntity.title);
    expect(playlist, findsOneWidget);
    await tester.tap(playlist);
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '|>').first);
    await tester.pump();
    expect(player!.state, PlayerState.playing);
    expect(find.textContaining('1:40'), findsOneWidget);
    expect(find.textContaining('0:00'), findsWidgets);
  });

  testWidgets('Persists state between sceens', (tester) async {
    await tester.pumpWidget(Cenoyam(getIt));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'query');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(data.trackEntity.title));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Play'));
    await tester.pump();

    player!.tick();
    await tester.pump();

    expect(player!.state, PlayerState.playing);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.5,
    );
    expect(find.textContaining('1:40'), findsOneWidget);
    expect(find.textContaining('0:50'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    final album = find.text(data.albumEntity.title);
    expect(album, findsOneWidget);
    await tester.tap(album);
    await tester.pumpAndSettle();

    player!.resend();
    await tester.pumpAndSettle();

    expect(
      find.text(
        '${data.trackEntity.artistString} - ${data.trackEntity.title}',
      ),
      findsOneWidget,
    );
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.5,
    );
    expect(find.textContaining('1:40'), findsOneWidget);
    expect(find.textContaining('0:50'), findsOneWidget);

    await tester.tap(find.text('||'));
    await tester.pump();

    expect(player!.state, PlayerState.paused);

    expect(find.widgetWithText(TextButton, '|>'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text(data.playlistEntity.title),
      find.byType(CustomScrollView),
      const Offset(0, -100),
    );
    final playlist = find.text(data.playlistEntity.title);
    expect(playlist, findsOneWidget);
    await tester.tap(playlist);
    await tester.pumpAndSettle();

    expect(
      find.text(
        '${data.trackEntity.artistString} - ${data.trackEntity.title}',
      ),
      findsOneWidget,
    );
    expect(
      tester
          .widget<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .value,
      0.5,
    );
    expect(find.textContaining('1:40'), findsOneWidget);
    expect(find.textContaining('0:50'), findsOneWidget);

    final playButton = find.widgetWithText(TextButton, '|>');
    expect(playButton, findsOneWidget);
    expect(tester.widget<TextButton>(playButton).enabled, true);
    await tester.tap(playButton);
    await tester.pump();

    expect(player!.state, PlayerState.playing);
    expect(player!._positionState, 1);

    player!.tick();
    await tester.pump();

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1,
    );
    expect(find.textContaining('1:40'), findsNWidgets(2));
  });
}

class FakePlayer extends Fake implements AudioPlayer {
  @override
  PlayerState state = PlayerState.stopped;
  final _durationController = StreamController<Duration>();
  final _positionController = StreamController<Duration>();
  final _playerStateController = StreamController<PlayerState>();
  var _positionState = 0;

  @override
  Stream<Duration> get onDurationChanged => _durationController.stream;
  @override
  Stream<Duration> get onPositionChanged => _positionController.stream;
  @override
  Stream<PlayerState> get onPlayerStateChanged => _playerStateController.stream;
  @override
  Future<Duration?> getDuration() {
    switch (state) {
      case PlayerState.stopped:
        return Future.value();
      case PlayerState.playing:
        return Future.value(const Duration(seconds: 100));
      case PlayerState.paused:
        return Future.value(const Duration(seconds: 100));
      case PlayerState.completed:
        return Future.value();
    }
  }

  @override
  Future<void> play(
    Source source, {
    double? volume,
    AudioContext? ctx,
    Duration? position,
    PlayerMode? mode,
  }) {
    state = PlayerState.playing;
    _playerStateController.add(PlayerState.playing);
    _durationController.add(const Duration(seconds: 100));
    _positionController.add(Duration.zero);
    _positionState = 0;
    return Future.value();
  }

  @override
  Future<void> pause() {
    expect(state, PlayerState.playing);
    state = PlayerState.paused;
    _playerStateController.add(PlayerState.paused);
    return Future.value();
  }

  @override
  Future<void> resume() {
    expect(state, PlayerState.paused);
    state = PlayerState.playing;
    _playerStateController.add(PlayerState.playing);
    return Future.value();
  }

  void tick() {
    expect(state, PlayerState.playing);
    switch (_positionState) {
      case 0:
        _positionState = 1;
        _positionController.add(const Duration(seconds: 50));
        break;
      case 1:
        _positionState = 2;
        _positionController.add(const Duration(seconds: 100));
        break;
      case 2:
        _positionState = 0;
        state = PlayerState.completed;
        _playerStateController.add(PlayerState.completed);
        _positionController.add(Duration.zero);
        _durationController.add(Duration.zero);
        break;
      default:
        assert(false, 'Unexpected position state');
    }
  }

  void resend() {
    _playerStateController.add(state);
    switch (_positionState) {
      case 0:
        _positionController.add(Duration.zero);
        switch (state) {
          case PlayerState.stopped:
            _durationController.add(Duration.zero);
            break;
          case PlayerState.playing:
            _durationController.add(const Duration(seconds: 100));
            break;
          case PlayerState.paused:
            _durationController.add(const Duration(seconds: 100));
            break;
          case PlayerState.completed:
            _durationController.add(Duration.zero);
            break;
        }
        break;
      case 1:
        _positionController.add(const Duration(seconds: 50));
        _durationController.add(const Duration(seconds: 100));
        break;
      case 2:
        _positionController.add(const Duration(seconds: 100));
        _durationController.add(const Duration(seconds: 100));
        break;
      default:
        assert(false, 'Unexpected position state');
    }
  }

  @override
  Future<void> dispose() {
    _durationController.close();
    _positionController.close();
    _playerStateController.close();
    return Future.value();
  }
}
