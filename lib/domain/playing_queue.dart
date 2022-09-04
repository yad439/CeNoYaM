import 'dart:async';
import 'dart:collection';

import 'package:injectable/injectable.dart';

import 'entity/track.dart';
import 'yandex_player.dart';

@singleton
class PlayingQueue {
  PlayingQueue(this._player) {
    _onCompleteSubscription = _player.onComplete.listen((_) => _onComplete());
  }

  final YandexPlayer _player;
  late final StreamSubscription<void> _onCompleteSubscription;
  final StreamController<TrackMin?> _trackStreamController =
      StreamController<TrackMin?>.broadcast();
  Queue<TrackMin> _queue = Queue<TrackMin>();

  Stream<TrackMin?> get currentTrack => _trackStreamController.stream;

  Future<void> play(List<TrackMin> list, {int fromIndex = 0}) {
    _queue = Queue<TrackMin>.of(
      list.skip(fromIndex).where((track) => track.available),
    );
    if (_queue.isNotEmpty) {
      final firstTrack = _queue.removeFirst();
      _trackStreamController.add(firstTrack);
      return _player.play(firstTrack.id);
    } else {
      return Future.value();
    }
  }

  void _onComplete() {
    if (_queue.isNotEmpty) {
      final nextTrack = _queue.removeFirst();
      _trackStreamController.add(nextTrack);
      _player.play(nextTrack.id);
    } else {
      _trackStreamController.add(null);
    }
  }

  @disposeMethod
  void dispose() {
    _onCompleteSubscription.cancel();
    _trackStreamController.close();
  }
}
