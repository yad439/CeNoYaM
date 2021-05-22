import 'package:json_annotation/json_annotation.dart';

import 'user_json.dart';
import 'track_json.dart';

part 'playlist_json.g.dart';

@JsonSerializable(createToJson: false)
class PlaylistMinJson {
  final int kind;
  final String title;
  final UserJson owner;

  PlaylistMinJson(this.kind, this.title, this.owner);

  factory PlaylistMinJson.fromJson(Map<String, dynamic> json) =>
      _$PlaylistMinJsonFromJson(json);
}

@JsonSerializable(createToJson: false)
class PlaylistJson extends PlaylistMinJson {
  List<TrackJson> tracks;

  PlaylistJson(int kind, String title, UserJson owner, this.tracks)
      : super(kind, title, owner);

  factory PlaylistJson.fromJson(Map<String, dynamic> json) =>
      _$PlaylistJsonFromJson(json);
}
