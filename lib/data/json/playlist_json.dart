import 'package:json_annotation/json_annotation.dart';

import 'track_json.dart';
import 'user_json.dart';

part 'playlist_json.g.dart';

@JsonSerializable(createToJson: false)
class PlaylistMinJson {
  PlaylistMinJson(this.kind, this.title, this.owner);

  factory PlaylistMinJson.fromJson(Map<String, dynamic> json) =>
      _$PlaylistMinJsonFromJson(json);
  final int kind;
  final String title;
  final UserJson owner;
}

@JsonSerializable(createToJson: false)
class PlaylistJson extends PlaylistMinJson {
  PlaylistJson(int kind, String title, UserJson owner, this.tracks)
      : super(kind, title, owner);

  factory PlaylistJson.fromJson(Map<String, dynamic> json) =>
      _$PlaylistJsonFromJson(json);
  List<TrackJson> tracks;
}
