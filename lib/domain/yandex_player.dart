import 'package:audioplayers/audioplayers.dart';

import 'music_repository.dart';

class YandexPlayer {
  YandexPlayer(this._player, this._musicRepository);
  final AudioPlayer _player;
  final MusicRepository _musicRepository;

  Future<void> play(int trackId) async {
    final url = await _musicRepository.getDownloadUrl(trackId);
    return _player.play(UrlSource(url.toString()));
  }

  void pause() => _player.pause();

  void resume() => _player.resume();

  void stop() => _player.stop();

  Future<Duration?> get duration => _player.getDuration();

  Stream<Duration> get durationStream => _player.onDurationChanged;

  Stream<Duration> get position => _player.onPositionChanged;
}
