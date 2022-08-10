import 'package:freezed_annotation/freezed_annotation.dart';

import 'track_json.dart';
import 'user_json.dart';

part 'playlist_json.freezed.dart';
part 'playlist_json.g.dart';

@Freezed(equal: true)
class PlaylistMinJson with _$PlaylistMinJson {
  const factory PlaylistMinJson(int kind, String title, UserJson owner) =
      _PlaylistMinJson;

  factory PlaylistMinJson.fromJson(Map<String, dynamic> json) =>
      _$PlaylistMinJsonFromJson(json);
}

@Freezed(equal: true)
class PlaylistJson with _$PlaylistJson implements PlaylistMinJson {
  const factory PlaylistJson(
    int kind,
    String title,
    UserJson owner,
    List<TrackJson> tracks,
  ) = _PlaylistJson;

  factory PlaylistJson.fromJson(Map<String, dynamic> json) =>
      _$PlaylistJsonFromJson(json);
}
