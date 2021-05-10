import 'package:json_annotation/json_annotation.dart';

import 'playlist_json.dart';

part 'playlist_box.g.dart';

@JsonSerializable(createToJson: false)
class PlaylistBox {
  PlaylistJson playlist;

  PlaylistBox(this.playlist);

  factory PlaylistBox.fromJson(Map<String, dynamic> json) =>
      _$PlaylistBoxFromJson(json);
}
