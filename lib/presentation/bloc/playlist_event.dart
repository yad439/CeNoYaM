import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_event.freezed.dart';

@immutable
@freezed
class PlaylistEvent with _$PlaylistEvent {
  const factory PlaylistEvent.load(String owner, int id) = LoadPlaylist;
}
