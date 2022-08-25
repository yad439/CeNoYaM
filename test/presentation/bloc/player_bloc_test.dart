import 'dart:async';

import 'package:cenoyam/domain/entity/track.dart';
import 'package:cenoyam/domain/enum/player_state.dart';
import 'package:cenoyam/domain/yandex_player.dart';
import 'package:cenoyam/presentation/bloc/player_bloc.dart';
import 'package:cenoyam/presentation/bloc/player_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<YandexPlayer>()])
import 'player_bloc_test.mocks.dart';

void main() {
  MockYandexPlayer? yandexPlayer;
  // ignore: close_sinks
  StreamController<Duration>? durationStream;
  // ignore: close_sinks
  StreamController<Duration>? position;
  // ignore: close_sinks
  StreamController<PlayerState>? state;
  PlayerBloc? bloc;
  setUp(() {
    yandexPlayer = MockYandexPlayer();
    durationStream = StreamController<Duration>();
    position = StreamController<Duration>();
    state = StreamController<PlayerState>();
    when(yandexPlayer!.durationStream)
        .thenAnswer((_) => durationStream!.stream);
    when(yandexPlayer!.position).thenAnswer((_) => position!.stream);
    when(yandexPlayer!.state).thenAnswer((_) => state!.stream);
    bloc = PlayerBloc(yandexPlayer!);
  });
  tearDown(() {
    bloc!.dispose();
    durationStream!.close();
    position!.close();
    state!.close();
    durationStream = null;
    position = null;
    state = null;
    yandexPlayer = null;
    bloc = null;
  });
  group('Progress', () {
    test('should return 0 when duration is null', () {
      when(yandexPlayer!.duration).thenAnswer((_) => Future.value());

      position!.add(const Duration(seconds: 1));

      expect(bloc!.progress, emitsInOrder([0]));
    });

    test('should return correct value when position changes', () async {
      when(yandexPlayer!.duration)
          .thenAnswer((_) => Future.value(const Duration(seconds: 10)));

      position!.add(Duration.zero);
      position!.add(const Duration(seconds: 5));
      position!.add(const Duration(seconds: 10));

      final progress = bloc!.progress;
      expect(progress, emitsInOrder([0, 0.5, 1]));
    });
  });

  group('Command', () {
    test('should call pause on pause command', () {
      final checker = expectAsync1((_) {});
      when(yandexPlayer!.pause()).thenAnswer(checker);

      bloc!.command.add(const PlayerEvent.pause());
    });

    test('should call resume on resume command', () {
      final checker = expectAsync1((_) {});
      when(yandexPlayer!.resume()).thenAnswer(checker);

      bloc!.command.add(const PlayerEvent.resume());
    });

    test('should call stop on stop command', () {
      final checker = expectAsync1((_) {});
      when(yandexPlayer!.stop()).thenAnswer(checker);

      bloc!.command.add(const PlayerEvent.stop());
    });

    test('should call play on play command', () {
      final checker = expectAsync1((_) => Future<void>.value());
      when(yandexPlayer!.play(any)).thenAnswer(checker);
      const track = TrackMin(1, 'title', true, 'artist');

      bloc!.command.add(const PlayerEvent.play(track));
    });

    test('should add track to currentTrack on play command', () {
      const track = TrackMin(1, 'title', true, 'artist');
      bloc!.command.add(const PlayerEvent.play(track));

      expect(bloc!.currentTrack, emits(track));
    });
  });
}
