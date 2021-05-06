import 'package:json_annotation/json_annotation.dart';

import 'track_json.dart';

part 'track_info.g.dart';

@JsonSerializable(createToJson: false)
class TrackInfo {
  TrackJson track;

  TrackInfo(this.track);

  factory TrackInfo.fromJson(Map<String, dynamic> json) =>
      _$TrackInfoFromJson(json);
}
