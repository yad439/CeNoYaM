// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistInfo _$ArtistInfoFromJson(Map<String, dynamic> json) {
  return ArtistInfo(
    ArtistJson.fromJson(json['artist'] as Map<String, dynamic>),
    (json['albums'] as List<dynamic>)
        .map((e) => AlbumMinJson.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['trackIds'] as List<dynamic>).map((e) => e as String).toList(),
  );
}
