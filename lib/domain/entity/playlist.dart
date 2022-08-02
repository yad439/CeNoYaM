import 'package:freezed_annotation/freezed_annotation.dart';

import 'track.dart';
import 'user.dart';

part 'playlist.freezed.dart';

@freezed
class PlaylistMin with _$PlaylistMin {
  const factory PlaylistMin(User owner, int id, String title) = _PlaylistMin;
}

@freezed
class Playlist with _$Playlist implements PlaylistMin {
  const factory Playlist(
    User owner,
    int id,
    String title,
    List<TrackMin> tracks,
  ) = _Playlist;
}
