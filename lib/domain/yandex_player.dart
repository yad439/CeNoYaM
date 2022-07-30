import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:injectable/injectable.dart';

import 'music_repository.dart';
import 'player_state.dart';

@singleton
class YandexPlayer {
  YandexPlayer(this._player, this._musicRepository);
  final audioplayers.AudioPlayer _player;
  final MusicRepository _musicRepository;

  Future<void> play(int trackId) async {
    final url = await _musicRepository.getDownloadUrl(trackId);
    return _player.play(audioplayers.UrlSource(url.toString()));
  }

  void pause() => _player.pause();

  void resume() => _player.resume();

  void stop() => _player.stop();

  Future<Duration?> get duration => _player.getDuration();

  Stream<Duration> get durationStream => _player.onDurationChanged;

  Stream<Duration> get position => _player.onPositionChanged;

  Stream<PlayerState> get state => _player.onPlayerStateChanged.map((event) {
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

  void dispose() {
    _player.dispose();
  }
}
