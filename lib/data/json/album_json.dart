import 'package:json_annotation/json_annotation.dart';

import 'artist_json.dart';
import 'track_json.dart';

part 'album_json.g.dart';

@JsonSerializable(createToJson: false)
class AlbumMinJson {
  AlbumMinJson(this.id, this.title, this.artists);

  factory AlbumMinJson.fromJson(Map<String, dynamic> json) =>
      _$AlbumMinJsonFromJson(json);
  final int id;
  final String title;
  final List<ArtistMinJson> artists;
}

@JsonSerializable(createToJson: false)
class AlbumJson extends AlbumMinJson {
  AlbumJson(super.id, super.title, super.artists, this.volumes);

  factory AlbumJson.fromJson(Map<String, dynamic> json) =>
      _$AlbumJsonFromJson(json);
  final List<List<TrackJson>> volumes;
}
