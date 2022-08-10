import 'package:freezed_annotation/freezed_annotation.dart';

import 'album_json.dart';
import 'artist_json.dart';

part 'artist_info.freezed.dart';
part 'artist_info.g.dart';

@Freezed(equal: true)
class ArtistInfo with _$ArtistInfo {
  const factory ArtistInfo(
    ArtistJson artist,
    List<AlbumMinJson> albums,
    List<String> trackIds,
  ) = _ArtistInfo;

  factory ArtistInfo.fromJson(Map<String, dynamic> json) =>
      _$ArtistInfoFromJson(json);
}
