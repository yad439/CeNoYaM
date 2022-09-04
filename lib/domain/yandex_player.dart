import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'enum/player_state.dart';
import 'music_repository.dart';

@singleton
class YandexPlayer {
  YandexPlayer(this._player, this._musicRepository)
      : _durationStream = _player.onDurationChanged.publishValue(),
        _position = _player.onPositionChanged.publishValue(),
        _state = _player.onPlayerStateChanged.publishValue() {
    _subscriptions = [
      _durationStream.connect(),
      _position.connect(),
      _state.connect()
    ];
  }
  final audioplayers.AudioPlayer _player;
  final MusicRepository _musicRepository;
  final ConnectableStream<Duration> _durationStream;
  final ConnectableStream<Duration> _position;
  final ConnectableStream<audioplayers.PlayerState> _state;
  late final List<StreamSubscription<Object>> _subscriptions;

  Future<void> play(int trackId) async {
    final url = await _musicRepository.getDownloadUrl(trackId);
    return _player.play(audioplayers.UrlSource(url.toString()));
  }

  void pause() => _player.pause();

  void resume() => _player.resume();

  void stop() => _player.stop();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<Duration?> get duration => _player.getDuration();

  Stream<Duration> get durationStream => _durationStream;

  Stream<Duration> get position => _position;

  Stream<PlayerState> get state => _state.map((event) {
        switch (event) {
          case audioplayers.PlayerState.stopped:
          case audioplayers.PlayerState.completed:
            return PlayerState.stopped;
          case audioplayers.PlayerState.playing:
            return PlayerState.playing;
          case audioplayers.PlayerState.paused:
            return PlayerState.paused;
        }
      });

  Stream<void> get onComplete => _player.onPlayerComplete;

  @disposeMethod
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }
}
