import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../domain/entity/track.dart';
import '../../domain/enum/player_state.dart';
import '../../domain/playing_queue.dart';
import '../../domain/yandex_player.dart';
import 'duration_state.dart';
import 'player_event.dart';

class PlayerBloc {
  PlayerBloc(this._player, this._playingQueue) {
    _eventSubscription = _eventController.stream.listen(_handleEvent);
  }
  final YandexPlayer _player;
  final PlayingQueue _playingQueue;
  final StreamController<PlayerEvent> _eventController =
      StreamController<PlayerEvent>();
  late final StreamSubscription<PlayerEvent> _eventSubscription;

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

  Stream<TrackMin?> get currentTrack => _playingQueue.currentTrack;

  Stream<DurationState> get durationState => Rx.combineLatest2(
        position,
        duration,
        DurationState.new,
      );

  void _handleEvent(PlayerEvent event) => event.when(
        pause: _pause,
        resume: _resume,
        stop: _stop,
        play: _play,
        playList: _playList,
        seek: _seek,
      );

  void _pause() {
    _player.pause();
  }

  void _resume() {
    _player.resume();
  }

  void _stop() {
    _player.stop();
  }

  void _play(TrackMin track) {
    _playingQueue.play([track]);
  }

  void _playList(List<TrackMin> list, int fromIndex) {
    _playingQueue.play(list, fromIndex: fromIndex);
  }

  void _seek(Duration position) {
    _player.seek(position);
  }

  void dispose() {
    _eventSubscription.cancel();
    _eventController.close();
  }
}
