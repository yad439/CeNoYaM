import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cenoyam/app.dart';
import 'package:cenoyam/data/json_mapper.dart';
import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:cenoyam/data/yandex_music_repository.dart';
import 'package:cenoyam/domain/music_repository.dart';
import 'package:cenoyam/domain/playing_queue.dart';
import 'package:cenoyam/domain/yandex_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../test_data.dart';

void main() {
  late final TestData data;
  FakePlayer? player;
  late final YandexMusicRepository repository;
  late final GetIt getIt;

  setUpAll(() {
    data = TestData();
    getIt = GetIt.asNewInstance();
    repository =
        YandexMusicRepository(YandexMusicDatasource(data.dio), JsonMapper());
  });

  setUp(() {
    player = FakePlayer();
    final yandexPlayer = YandexPlayer(player!, repository);
    getIt
      ..registerSingleton(yandexPlayer)
      ..registerSingleton<MusicRepository>(repository)
      ..registerSingleton<PlayingQueue>(PlayingQueue(yandexPlayer));
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
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      Duration.zero,
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
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      Duration.zero,
    );
    // expect(find.textContaining('1:40'), findsOneWidget);
    // expect(find.textContaining('0:00'), findsWidgets);

    final progressBar = find.byType(ProgressBar);
    expect(progressBar, findsOneWidget);
    final topLeft = tester.getTopLeft(progressBar);
    final bottomRight = tester.getBottomRight(progressBar);
    await tester.tapAt(
      Offset(
        0.7 * topLeft.dx + 0.3 * bottomRight.dx,
        (topLeft.dy + bottomRight.dy) / 2,
      ),
    );
    await tester.pump();
    expect(player!._position, greaterThan(const Duration(seconds: 29)));
    expect(player!._position, lessThan(const Duration(seconds: 31)));
    expect(
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      greaterThan(const Duration(seconds: 29)),
    );
    expect(
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      lessThan(const Duration(seconds: 31)),
    );

    player!.tick();
    await tester.pump();
    expect(
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      const Duration(seconds: 50),
    );
    // expect(find.textContaining('1:40'), findsOneWidget);
    // expect(find.textContaining('0:50'), findsOneWidget);

    await tester.tap(find.text('||'));
    await tester.pump();

    expect(player!.state, PlayerState.paused);

    await tester.tap(find.text('|>'));
    await tester.pump();
    expect(player!.state, PlayerState.playing);

    player!.tick();
    await tester.pump();

    expect(
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      const Duration(seconds: 100),
    );
    // expect(find.textContaining('1:40'), findsNWidgets(2));

    player!.tick();
    await tester.pump();

    expect(
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      Duration.zero,
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
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      Duration.zero,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '|>').first);
    await tester.pump();
    expect(player!.state, PlayerState.playing);
    expect(player!._trackUrl, contains('something/abc'));

    expect(
      find.text(
        '${data.trackEntity.artistString} - ${data.trackEntity.title}',
      ),
      findsNWidgets(2),
    );

    player!.tick();
    player!.tick();
    player!.tick();
    await tester.runAsync(
      // wait for "play" to complete
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();

    expect(player!.state, PlayerState.playing);
    expect(player!._trackUrl, contains('another/abc'));
    final track2 = data.trackWithMultipleArtistsEntity;
    expect(
      find.text('${track2.artistString} - ${track2.title}'),
      findsNWidgets(2),
    );

    player!.tick();
    player!.tick();
    player!.tick();
    await tester.pump();

    expect(player!.state, PlayerState.completed);

    await tester.runAsync(
      // wait for queue to send null track
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('Plays from album from the middle', (tester) async {
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
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      Duration.zero,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '|>').at(2));
    await tester.pump();

    expect(player!.state, PlayerState.playing);
    expect(player!._trackUrl, contains('another/abc'));
    final track2 = data.trackWithMultipleArtistsEntity;
    expect(
      find.text('${track2.artistString} - ${track2.title}'),
      findsNWidgets(2),
    );

    player!.tick();
    player!.tick();
    player!.tick();
    await tester.pump();

    expect(player!.state, PlayerState.completed);

    await tester.runAsync(
      // wait for queue to send null track
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();

    expect(find.text('-'), findsOneWidget);
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
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      Duration.zero,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '|>').first);
    await tester.pump();
    expect(player!.state, PlayerState.playing);
    expect(player!._trackUrl, contains('something/abc'));

    expect(
      find.text(
        '${data.trackEntity.artistString} - ${data.trackEntity.title}',
      ),
      findsNWidgets(2),
    );

    player!.tick();
    player!.tick();
    player!.tick();
    await tester.runAsync(
      // wait for "play" to complete
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();

    expect(player!.state, PlayerState.playing);
    expect(player!._trackUrl, contains('another/abc'));
    final track2 = data.trackWithMultipleArtistsEntity;
    expect(
      find.text('${track2.artistString} - ${track2.title}'),
      findsNWidgets(2),
    );

    player!.tick();
    player!.tick();
    player!.tick();
    await tester.pump();

    expect(player!.state, PlayerState.completed);

    await tester.runAsync(
      // wait for queue to send null track
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('Plays from playlist from the middle', (tester) async {
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
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      Duration.zero,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '|>').at(2));
    await tester.pump();

    expect(player!.state, PlayerState.playing);
    expect(player!._trackUrl, contains('another/abc'));
    final track2 = data.trackWithMultipleArtistsEntity;
    expect(
      find.text('${track2.artistString} - ${track2.title}'),
      findsNWidgets(2),
    );

    player!.tick();
    player!.tick();
    player!.tick();
    await tester.pump();

    expect(player!.state, PlayerState.completed);

    await tester.runAsync(
      // wait for queue to send null track
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('Plays from artist', (tester) async {
    await tester.pumpWidget(Cenoyam(getIt));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'query');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    final artist = find.byWidgetPredicate(
      (widget) =>
          widget is ListTile &&
          widget.title is Text &&
          (widget.title as Text?)?.data == data.artistEntity.name,
    );
    expect(artist, findsOneWidget);
    await tester.tap(artist);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tracks'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      Duration.zero,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '|>').first);
    await tester.pump();
    expect(player!.state, PlayerState.playing);
    expect(player!._trackUrl, contains('something/abc'));

    expect(
      find.text(
        '${data.trackEntity.artistString} - ${data.trackEntity.title}',
      ),
      findsNWidgets(2),
    );

    player!.tick();
    player!.tick();
    player!.tick();
    await tester.runAsync(
      // wait for "play" to complete
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();

    expect(player!.state, PlayerState.playing);
    expect(player!._trackUrl, contains('another/abc'));
    final track2 = data.trackWithMultipleArtistsEntity;
    expect(
      find.text('${track2.artistString} - ${track2.title}'),
      findsNWidgets(2),
    );

    player!.tick();
    player!.tick();
    player!.tick();
    await tester.pump();

    expect(player!.state, PlayerState.completed);

    await tester.runAsync(
      // wait for queue to send null track
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('Plays from artist from the middle', (tester) async {
    await tester.pumpWidget(Cenoyam(getIt));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'query');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    final artist = find.byWidgetPredicate(
      (widget) =>
          widget is ListTile &&
          widget.title is Text &&
          (widget.title as Text?)?.data == data.artistEntity.name,
    );
    expect(artist, findsOneWidget);
    await tester.tap(artist);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tracks'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      Duration.zero,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '|>').at(1));
    await tester.pump();

    expect(player!.state, PlayerState.playing);
    expect(player!._trackUrl, contains('another/abc'));
    final track2 = data.trackWithMultipleArtistsEntity;
    expect(
      find.text('${track2.artistString} - ${track2.title}'),
      findsNWidgets(2),
    );

    player!.tick();
    player!.tick();
    player!.tick();
    await tester.pump();

    expect(player!.state, PlayerState.completed);

    await tester.runAsync(
      // wait for queue to send null track
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();

    expect(find.text('-'), findsOneWidget);
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
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      const Duration(seconds: 50),
    );
    // expect(find.textContaining('1:40'), findsOneWidget);
    // expect(find.textContaining('0:50'), findsOneWidget);

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
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      const Duration(seconds: 50),
    );
    // expect(find.textContaining('1:40'), findsOneWidget);
    // expect(find.textContaining('0:50'), findsOneWidget);

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
          .widget<ProgressBar>(
            find.byType(ProgressBar),
          )
          .progress,
      const Duration(seconds: 50),
    );
    // expect(find.textContaining('1:40'), findsOneWidget);
    // expect(find.textContaining('0:50'), findsOneWidget);

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
      tester.widget<ProgressBar>(find.byType(ProgressBar)).progress,
      const Duration(seconds: 100),
    );
    // expect(find.textContaining('1:40'), findsNWidgets(2));
  });
}

class FakePlayer extends Fake implements AudioPlayer {
  @override
  PlayerState state = PlayerState.stopped;
  final _durationController = StreamController<Duration>();
  final _positionController = StreamController<Duration>();
  final _playerStateController = StreamController<PlayerState>();
  final _playerCompleteController = StreamController<void>();
  var _positionState = 0;
  var _position = Duration.zero;
  var _trackUrl = '';

  @override
  Stream<Duration> get onDurationChanged => _durationController.stream;
  @override
  Stream<Duration> get onPositionChanged => _positionController.stream;
  @override
  Stream<PlayerState> get onPlayerStateChanged => _playerStateController.stream;
  @override
  Stream<void> get onPlayerComplete => _playerCompleteController.stream;
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
    _position = Duration.zero;
    _trackUrl = (source as UrlSource).url;
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

  @override
  Future<void> seek(Duration position) {
    _position = position;
    _positionController.add(position);
    return Future.value();
  }

  void tick() {
    expect(state, PlayerState.playing);
    switch (_positionState) {
      case 0:
        _positionState = 1;
        _position = const Duration(seconds: 50);
        _positionController.add(const Duration(seconds: 50));
        break;
      case 1:
        _positionState = 2;
        _position = const Duration(seconds: 100);
        _positionController.add(const Duration(seconds: 100));
        break;
      case 2:
        _positionState = 0;
        state = PlayerState.completed;
        _position = Duration.zero;
        _playerStateController.add(PlayerState.completed);
        _positionController.add(Duration.zero);
        _durationController.add(Duration.zero);
        _playerCompleteController.add(null);
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
    _playerCompleteController.close();
    return Future.value();
  }
}
