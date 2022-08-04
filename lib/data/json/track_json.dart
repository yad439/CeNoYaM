import 'package:json_annotation/json_annotation.dart';

import 'album_json.dart';
import 'artist_json.dart';

part 'track_json.g.dart';

@JsonSerializable(createToJson: false)
class TrackJson {
  TrackJson(this.id, this.title, this.artists, this.albums);

  factory TrackJson.fromJson(Map<String, dynamic> json) =>
      _$TrackJsonFromJson(json);
  @JsonKey(fromJson: _toString)
  final String id;

  final String title;
  final List<ArtistMinJson> artists;
  final List<AlbumMinJson> albums;
}

String _toString(Object obj)=>obj.toString();
