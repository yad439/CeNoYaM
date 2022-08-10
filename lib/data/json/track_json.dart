import 'package:freezed_annotation/freezed_annotation.dart';

import 'album_json.dart';
import 'artist_json.dart';
import 'util.dart';

part 'track_json.freezed.dart';
part 'track_json.g.dart';

@Freezed(equal: true)
class TrackJson with _$TrackJson {
  const factory TrackJson(
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: objectToInt) int id,
    String title,
    // ignore: avoid_positional_boolean_parameters
    bool available,
    List<ArtistJson> artists,
    List<AlbumMinJson> albums,
  ) = _TrackJson;

  factory TrackJson.fromJson(Map<String, dynamic> json) =>
      _$TrackJsonFromJson(json);
}
