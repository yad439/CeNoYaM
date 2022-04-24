import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'playlist_event.freezed.dart';

@immutable
@freezed
class PlaylistEvent with _$PlaylistEvent {
  const factory PlaylistEvent.load(String owner, int id) = _Load;
}
