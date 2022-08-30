import 'package:freezed_annotation/freezed_annotation.dart';

import 'album.dart';
import 'track.dart';

part 'artist.freezed.dart';

@freezed
class ArtistMin with _$ArtistMin {
  const factory ArtistMin(int id, String name) = _ArtistMin;
}

@freezed
class Artist with _$Artist implements ArtistMin {
  const factory Artist(
    int id,
    String name,
    List<AlbumMin> albums,
    List<TrackMin> popularTracks,
  ) = _Artist;
}
