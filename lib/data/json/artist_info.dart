import 'package:json_annotation/json_annotation.dart';

import 'artist_json.dart';
import 'album_json.dart';

part 'artist_info.g.dart';

@JsonSerializable(createToJson: false)
class ArtistInfo {
  ArtistJson artist;
  List<AlbumMinJson> albums;
  List<String> trackIds;

  ArtistInfo(this.artist, this.albums, this.trackIds);

  factory ArtistInfo.fromJson(Map<String, dynamic> json) =>
      _$ArtistInfoFromJson(json);
}
