import 'package:audioplayers/audioplayers.dart';

import 'music_repository.dart';

class YandexPlayer {
  final AudioPlayer _player;
  final MusicRepository _musicRepository;

  YandexPlayer(this._player, this._musicRepository);

  void play(int trackId) async {
    final url = await _musicRepository.getDownloadUrl(trackId);
    _player.play(url.toString());
  }

  void pause() => _player.pause();

  void resume() => _player.resume();

  void stop() => _player.stop();
}