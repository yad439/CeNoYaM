import 'package:freezed_annotation/freezed_annotation.dart';

import 'track_json.dart';

part 'track_box.freezed.dart';
part 'track_box.g.dart';

@Freezed(equal: true)
class TrackBox with _$TrackBox {
  const factory TrackBox(TrackJson track) = _TrackBox;

  factory TrackBox.fromJson(Map<String, dynamic> json) =>
      _$TrackBoxFromJson(json);
}
