import 'package:freezed_annotation/freezed_annotation.dart';

import 'playlist_json.dart';

part 'playlist_box.freezed.dart';
part 'playlist_box.g.dart';

@Freezed(equal: true)
class PlaylistBox with _$PlaylistBox {
  const factory PlaylistBox(PlaylistJson playlist) = _PlaylistBox;

  factory PlaylistBox.fromJson(Map<String, dynamic> json) =>
      _$PlaylistBoxFromJson(json);
}
