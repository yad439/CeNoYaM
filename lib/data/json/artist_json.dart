import 'package:json_annotation/json_annotation.dart';

part 'artist_json.g.dart';

@JsonSerializable(createToJson: false)
class ArtistMinJson {
  ArtistMinJson(this.id, this.name);

  factory ArtistMinJson.fromJson(Map<String, dynamic> json) =>
      _$ArtistMinJsonFromJson(json);
  final int id;
  final String name;
}

@JsonSerializable(createToJson: false)
class ArtistJson extends ArtistMinJson {
  ArtistJson(String id, String name) : super(int.parse(id), name);

  factory ArtistJson.fromJson(Map<String, dynamic> json) =>
      _$ArtistJsonFromJson(json);
}
