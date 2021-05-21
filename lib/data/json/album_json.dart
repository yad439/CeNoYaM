import 'package:json_annotation/json_annotation.dart';

import 'artist_json.dart';
import 'track_json.dart';

part 'album_json.g.dart';

@JsonSerializable(createToJson: false)
class AlbumMinJson {
  int id;
  String title;

  AlbumMinJson(this.id, this.title);

  factory AlbumMinJson.fromJson(Map<String, dynamic> json) =>
      _$AlbumMinJsonFromJson(json);
}

@JsonSerializable(createToJson: false)
class AlbumJson extends AlbumMinJson {
  List<ArtistMinJson> artists;
  List<List<TrackJson>> volumes;

  AlbumJson(id, title, this.artists, this.volumes) : super(id, title);

  factory AlbumJson.fromJson(Map<String, dynamic> json) =>
      _$AlbumJsonFromJson(json);
}
