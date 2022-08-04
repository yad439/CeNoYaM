import 'dart:async';

import '../../domain/entity/track.dart';
import '../../domain/player_state.dart';
import '../../domain/yandex_player.dart';
import 'player_event.dart';

class PlayerBloc {
  PlayerBloc(this._player) {
    _eventController.stream.listen(_handleEvent);
  }
  final YandexPlayer _player;
  final StreamController<TrackMin?> _trackController =
      StreamController<TrackMin?>();
  final StreamController<PlayerEvent> _eventController =
      StreamController<PlayerEvent>();

  Sink<PlayerEvent> get command => _eventController.sink;

  Stream<PlayerState> get state => _player.state;

  Stream<Duration> get duration => _player.durationStream;

  Stream<Duration> get position => _player.position;

  Stream<double> get progress => _player.position.asyncMap(
        (event) => _player.duration.then(
          (value) =>
              value != null ? event.inMilliseconds / value.inMilliseconds : 0,
        ),
      );

  Stream<TrackMin?> get currentTrack => _trackController.stream;

  void _handleEvent(PlayerEvent event) => event.when(
        pause: _pause,
        resume: _resume,
        stop: _stop,
        play: _play,
      );

  void _pause() {
    _player.pause();
  }

  void _resume() {
    _player.resume();
  }

  void _stop() {
    _player.stop();
    _trackController.sink.add(null);
  }

  void _play(TrackMin track) {
    _player.play(track.id);
    _trackController.sink.add(track);
  }

  void dispose() {
    _eventController.close();
    _trackController.close();
  }
}
