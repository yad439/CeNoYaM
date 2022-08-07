import 'package:freezed_annotation/freezed_annotation.dart';

import '../util.dart';
import 'artist.dart';
import 'track.dart';

part 'album.freezed.dart';

@freezed
class AlbumMin with _$AlbumMin {
  const factory AlbumMin(int id, String title, String artistString) = _AlbumMin;
}

@freezed
class Album with _$Album implements AlbumMin {
  const factory Album(
    int id,
    String title,
    List<ArtistMin> artists,
    List<TrackMin> tracks,
  ) = _Album;
  const Album._();

  @override
  String get artistString => generateArtistString(artists.map((e) => e.name));
}
