// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistJson _$PlaylistJsonFromJson(Map<String, dynamic> json) {
  return PlaylistJson(
    json['kind'] as int,
    json['title'] as String,
    UserJson.fromJson(json['owner'] as Map<String, dynamic>),
    (json['tracks'] as List<dynamic>)
        .map((e) => TrackJson.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
