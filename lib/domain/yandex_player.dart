import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:injectable/injectable.dart';

import 'enum/player_state.dart';
import 'music_repository.dart';

@singleton
class YandexPlayer {
  YandexPlayer(this._player, this._musicRepository)
      : _durationStream = _player.onDurationChanged.asBroadcastStream(),
        _position = _player.onPositionChanged.asBroadcastStream(),
        _state = _player.onPlayerStateChanged.asBroadcastStream();
  final audioplayers.AudioPlayer _player;
  final MusicRepository _musicRepository;
  final Stream<Duration> _durationStream;
  final Stream<Duration> _position;
  final Stream<audioplayers.PlayerState> _state;

  Future<void> play(int trackId) async {
    final url = await _musicRepository.getDownloadUrl(trackId);
    return _player.play(audioplayers.UrlSource(url.toString()));
  }

  void pause() => _player.pause();

  void resume() => _player.resume();

  void stop() => _player.stop();

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
}
