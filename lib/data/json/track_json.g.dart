// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackJson _$TrackJsonFromJson(Map<String, dynamic> json) {
  return TrackJson(
    json['id'] as String,
    json['title'] as String,
    (json['artists'] as List<dynamic>)
        .map((e) => ArtistMinJson.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['albums'] as List<dynamic>)
        .map((e) => AlbumMinJson.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
