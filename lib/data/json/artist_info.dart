import 'package:json_annotation/json_annotation.dart';

import 'album_json.dart';
import 'artist_json.dart';

part 'artist_info.g.dart';

@JsonSerializable(createToJson: false)
class ArtistInfo {
  ArtistInfo(this.artist, this.albums, this.trackIds);

  factory ArtistInfo.fromJson(Map<String, dynamic> json) =>
      _$ArtistInfoFromJson(json);
  final ArtistJson artist;
  final List<AlbumMinJson> albums;
  final List<String> trackIds;
}
