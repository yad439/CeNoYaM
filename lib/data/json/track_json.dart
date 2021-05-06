import 'package:json_annotation/json_annotation.dart';

import 'album_json.dart';
import 'artist_json.dart';

part 'track_json.g.dart';

@JsonSerializable(createToJson: false)
class TrackJson {
  final int id;
  final String title;
  final List<ArtistJson> artists;
  final List<AlbumJson> albums;

  TrackJson(this.id, this.title, this.artists, this.albums);

  factory TrackJson.fromJson(Map<String, dynamic> json) =>
      _$TrackJsonFromJson(json);
}
