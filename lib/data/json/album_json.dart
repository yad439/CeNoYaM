import 'package:freezed_annotation/freezed_annotation.dart';

import 'artist_json.dart';
import 'track_json.dart';

part 'album_json.freezed.dart';
part 'album_json.g.dart';

@Freezed(equal: true)
class AlbumMinJson with _$AlbumMinJson {
  const factory AlbumMinJson(
    int id,
    String title,
    List<ArtistJson> artists,
  ) = _AlbumMinJson;

  factory AlbumMinJson.fromJson(Map<String, dynamic> json) =>
      _$AlbumMinJsonFromJson(json);
}

@Freezed(equal: true)
class AlbumJson with _$AlbumJson implements AlbumMinJson {
  const factory AlbumJson(
    int id,
    String title,
    List<ArtistJson> artists,
    List<List<TrackJson>> volumes,
  ) = _AlbumJson;

  factory AlbumJson.fromJson(Map<String, dynamic> json) =>
      _$AlbumJsonFromJson(json);
}
