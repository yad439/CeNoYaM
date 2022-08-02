import 'package:freezed_annotation/freezed_annotation.dart';

import 'album_json.dart';
import 'artist_json.dart';
import 'playlist_json.dart';
import 'track_json.dart';

part 'search_response.freezed.dart';

@immutable
@Freezed(fromJson: false)
class SearchResponse with _$SearchResponse {
  const factory SearchResponse(
    SearchEntry<AlbumMinJson> albums,
    SearchEntry<TrackJson> tracks,
    SearchEntry<ArtistMinJson> artists,
    SearchEntry<PlaylistMinJson> playlists,
  ) = _SearchResponse;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        SearchEntry<AlbumMinJson>.fromJson(
          json['albums'] as Map<String, dynamic>,
          AlbumMinJson.fromJson,
        ),
        SearchEntry<TrackJson>.fromJson(
          json['tracks'] as Map<String, dynamic>,
          TrackJson.fromJson,
        ),
        SearchEntry<ArtistMinJson>.fromJson(
          json['artists'] as Map<String, dynamic>,
          ArtistMinJson.fromJson,
        ),
        SearchEntry<PlaylistMinJson>.fromJson(
          json['playlists'] as Map<String, dynamic>,
          PlaylistMinJson.fromJson,
        ),
      );
}

@immutable
@Freezed(fromJson: false)
class SearchEntry<T> with _$SearchEntry<T> {
  const factory SearchEntry(List<T> items) = _SearchEntry;

  factory SearchEntry.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) =>
      SearchEntry<T>(
        (json['items'] as List<dynamic>)
            .map((e) => fromJsonT(e as Map<String, dynamic>))
            .toList(growable: false),
      );
}
