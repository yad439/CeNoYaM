import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/track.dart';

part 'player_event.freezed.dart';

@immutable
@freezed
class PlayerEvent with _$PlayerEvent {
  const factory PlayerEvent.pause() = _Pause;

  const factory PlayerEvent.resume() = _Resume;

  const factory PlayerEvent.stop() = _Stop;

  const factory PlayerEvent.play(Track track) = _Play;
}
