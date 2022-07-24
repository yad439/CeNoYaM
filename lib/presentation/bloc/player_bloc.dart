import 'dart:async';

import '../../domain/entity/track.dart';
import '../../domain/yandex_player.dart';
import 'player_event.dart';

class PlayerBloc {
  final YandexPlayer _player;
  final StreamController<Track?> _trackController = StreamController<Track?>();
  final StreamController<bool> _playingController = StreamController<bool>();
  final StreamController<PlayerEvent> _eventController =
      StreamController<PlayerEvent>();

  PlayerBloc(this._player) {
    _eventController.stream.listen(_handleEvent);
  }

  Sink<PlayerEvent> get command => _eventController.sink;

  Stream<bool> get isPlaying => _playingController.stream;

  Stream<Duration> get duration => _player.durationStream;

  Stream<Duration> get position => _player.position;

  Stream<double> get progress => _player.position.asyncMap((event) => _player
      .duration
      .then((value) => value != null ? value.inSeconds / event.inSeconds : 0));

  Stream<Track?> get currentTrack => _trackController.stream;

  void _handleEvent(PlayerEvent event) => event.when(
      pause: () => _pause(),
      resume: () => _resume(),
      stop: () => _stop(),
      play: (track) => _play(track));

  void _pause() {
    _player.pause();
    _playingController.sink.add(false);
  }

  void _resume() {
    _player.resume();
    _playingController.sink.add(true);
  }

  void _stop() {
    _player.stop();
    _playingController.sink.add(false);
    _trackController.sink.add(null);
  }

  void _play(Track track) {
    _player.play(track.id);
    _trackController.sink.add(track);
    _playingController.sink.add(true);
  }

  void dispose() {
    _eventController.close();
    _trackController.close();
    _playingController.close();
  }
}
