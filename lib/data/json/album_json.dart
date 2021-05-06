import 'package:json_annotation/json_annotation.dart';

part 'album_json.g.dart';

@JsonSerializable(createToJson: false)
class AlbumJson {
  int id;
  String title;

  AlbumJson(this.id, this.title);

  factory AlbumJson.fromJson(Map<String, dynamic> json) =>
      _$AlbumJsonFromJson(json);
}
