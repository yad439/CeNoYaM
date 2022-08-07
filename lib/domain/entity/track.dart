import 'package:freezed_annotation/freezed_annotation.dart';

import '../util.dart';
import 'album.dart';
import 'artist.dart';

part 'track.freezed.dart';

@freezed
class TrackMin with _$TrackMin {
  const factory TrackMin(
    int id,
    String title,
    // ignore: avoid_positional_boolean_parameters
    bool available,
    String artistString,
  ) = _TrackMin;
}

@freezed
class Track with _$Track implements TrackMin {
  const factory Track(
    int id,
    String title,
    // ignore: avoid_positional_boolean_parameters
    bool available,
    List<AlbumMin> albums,
    List<ArtistMin> artists,
  ) = _Track;
  const Track._();

  @override
  String get artistString => generateArtistString(artists.map((e) => e.name));
}
