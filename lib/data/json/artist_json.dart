import 'package:json_annotation/json_annotation.dart';

part 'artist_json.g.dart';

@JsonSerializable(createToJson: false)
class ArtistMinJson {
  int id;
  String name;

  ArtistMinJson(this.id, this.name);

  factory ArtistMinJson.fromJson(Map<String, dynamic> json) =>
      _$ArtistMinJsonFromJson(json);
}
