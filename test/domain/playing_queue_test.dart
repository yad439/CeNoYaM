import 'dart:async';

import 'package:cenoyam/domain/entity/track.dart';
import 'package:cenoyam/domain/playing_queue.dart';
import 'package:cenoyam/domain/yandex_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<YandexPlayer>()])
import 'playing_queue_test.mocks.dart';

void main() {
  final player = MockYandexPlayer();
  late PlayingQueue queue;
  late StreamController<void> complete;
  setUp(() {
    complete = StreamController<void>(sync: true);
    when(player.onComplete).thenAnswer((_) => complete.stream);
    queue = PlayingQueue(player);
  });
  tearDown(() {
    queue.dispose();
    complete.close();
    reset(player);
  });
  group('Should play', () {
    const track1 = TrackMin(1, 'title', true, 'artist');
    const track2 = TrackMin(2, 'title', true, 'artist');
    const track3 = TrackMin(3, 'title', true, 'artist');
    const tracks = [track1, track2, track3];
    test('single track', () {
      const track = TrackMin(1, 'title', true, 'artist');

      queue.play(const [track]);

      verify(player.play(track.id));
    });
    test('multiple track', () {
      queue.play(tracks);

      verify(player.play(track1.id));
      complete.add(null);
      verify(player.play(track2.id));
      complete.add(null);
      verify(player.play(track3.id));
      complete.add(null);
      verifyNever(player.play(any));
    });

    test('from given index', () {
      queue.play(tracks, fromIndex: 1);

      verify(player.play(track2.id));
      complete.add(null);
      verify(player.play(track3.id));
      complete.add(null);
      verifyNever(player.play(any));
    });
  });

  test('Should emit current track', () {
    const track1 = TrackMin(1, 'title', true, 'artist');
    const track2 = TrackMin(2, 'title', true, 'artist');
    const track3 = TrackMin(3, 'title', true, 'artist');
    final output = StreamController<TrackMin?>();
    addTearDown(output.close);
    queue.currentTrack.pipe(output);

    queue.play(const [track1, track2, track3]);

    complete
      ..add(null)
      ..add(null)
      ..add(null);
    expect(output.stream, emitsInOrder(const [track1, track2, track3, null]));
  });

  group('Should skip', () {
    test('unavailable track in the begining', () {
      const track1 = TrackMin(1, 'title', false, 'artist');
      const track2 = TrackMin(2, 'title', true, 'artist');
      const track3 = TrackMin(3, 'title', true, 'artist');

      queue.play(const [track1, track2, track3]);

      verify(player.play(track2.id));
    });

    test('unavailable track in the middle', () {
      const track1 = TrackMin(1, 'title', true, 'artist');
      const track2 = TrackMin(2, 'title', false, 'artist');
      const track3 = TrackMin(3, 'title', true, 'artist');

      queue.play(const [track1, track2, track3]);

      verify(player.play(track1.id));
      complete.add(null);
      verify(player.play(track3.id));
    });

    test('multiple unavailable tracks in the begining', () {
      const track1 = TrackMin(1, 'title', false, 'artist');
      const track2 = TrackMin(2, 'title', false, 'artist');
      const track3 = TrackMin(3, 'title', true, 'artist');

      queue.play(const [track1, track2, track3]);

      verify(player.play(track3.id));
    });

    test('multiple unavailable tracks in the middle', () {
      const track1 = TrackMin(1, 'title', true, 'artist');
      const track2 = TrackMin(2, 'title', false, 'artist');
      const track3 = TrackMin(3, 'title', false, 'artist');
      const track4 = TrackMin(4, 'title', true, 'artist');

      queue.play(const [track1, track2, track3, track4]);

      verify(player.play(track1.id));
      complete.add(null);
      verify(player.play(track4.id));
    });

    test('unavailable tracks in the end', () {
      const track1 = TrackMin(1, 'title', true, 'artist');
      const track2 = TrackMin(2, 'title', false, 'artist');
      const track3 = TrackMin(3, 'title', false, 'artist');
      final output = StreamController<TrackMin?>();
      addTearDown(output.close);
      queue.currentTrack.pipe(output);

      queue.play(const [track1, track2, track3]);

      verify(player.play(track1.id));
      complete.add(null);
      verifyNever(player.play(any));
      expect(output.stream, emitsInOrder(const [track1, null]));
    });
  });

  group("Shouldn't play", () {
    test('empty list', () {
      queue.play(const []);

      verifyNever(player.play(any));
    });

    test('unavailable track', () {
      const track = TrackMin(1, 'title', false, 'artist');

      queue.play(const [track]);

      verifyNever(player.play(any));
    });
  });
}
