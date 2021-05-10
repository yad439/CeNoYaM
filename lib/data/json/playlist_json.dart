import 'package:json_annotation/json_annotation.dart';

import 'user_json.dart';
import 'track_json.dart';

part 'playlist_json.g.dart';

@JsonSerializable(createToJson: false)
class PlaylistJson {
  int kind;
  String title;
  UserJson owner;
  List<TrackJson> tracks;

  PlaylistJson(this.kind, this.title, this.owner, this.tracks);

  factory PlaylistJson.fromJson(Map<String, dynamic> json) =>
      _$PlaylistJsonFromJson(json);
}
