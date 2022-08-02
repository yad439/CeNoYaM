import 'package:freezed_annotation/freezed_annotation.dart';

import 'album.dart';
import 'artist.dart';
import 'playlist.dart';
import 'track.dart';

part 'search_results.freezed.dart';

@immutable
@freezed
class SearchResults with _$SearchResults {
  const factory SearchResults(
    List<TrackMin> tracks,
    List<ArtistMin> artists,
    List<AlbumMin> albums,
    List<PlaylistMin> playlists,
  ) = _SearchResults;
}
