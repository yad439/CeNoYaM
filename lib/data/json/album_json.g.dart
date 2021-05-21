// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumMinJson _$AlbumMinJsonFromJson(Map<String, dynamic> json) {
  return AlbumMinJson(
    json['id'] as int,
    json['title'] as String,
  );
}

AlbumJson _$AlbumJsonFromJson(Map<String, dynamic> json) {
  return AlbumJson(
    json['id'] as int,
    json['title'] as String,
    (json['artists'] as List<dynamic>)
        .map((e) => ArtistMinJson.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['volumes'] as List<dynamic>)
        .map((e) => (e as List<dynamic>)
            .map((e) => TrackJson.fromJson(e as Map<String, dynamic>))
            .toList())
        .toList(),
  );
}
