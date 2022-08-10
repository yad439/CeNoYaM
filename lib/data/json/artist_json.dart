import 'package:freezed_annotation/freezed_annotation.dart';

import 'util.dart';

part 'artist_json.freezed.dart';
part 'artist_json.g.dart';

@Freezed(equal: true)
class ArtistJson with _$ArtistJson {
  const factory ArtistJson(
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: objectToInt) int id,
    String name,
  ) = _ArtistJson;

  factory ArtistJson.fromJson(Map<String, dynamic> json) =>
      _$ArtistJsonFromJson(json);
}
