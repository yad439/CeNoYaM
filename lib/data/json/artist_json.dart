import 'package:json_annotation/json_annotation.dart';

part 'artist_json.g.dart';

@JsonSerializable(createToJson: false)
class ArtistJson {
  int id;
  String name;

  ArtistJson(this.id, this.name);

  factory ArtistJson.fromJson(Map<String, dynamic> json) =>
      _$ArtistJsonFromJson(json);
}
