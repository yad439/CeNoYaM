import 'package:json_annotation/json_annotation.dart';

import 'track_json.dart';

part 'track_box.g.dart';

@JsonSerializable(createToJson: false)
class TrackBox {
  final TrackJson track;

  TrackBox(this.track);

  factory TrackBox.fromJson(Map<String, dynamic> json) =>
      _$TrackBoxFromJson(json);
}
