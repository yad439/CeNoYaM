import 'package:json_annotation/json_annotation.dart';

part 'user_json.g.dart';

@JsonSerializable(createToJson: false)
class UserJson {
  final int uid;
  final String login;

  UserJson(this.uid, this.login);

  factory UserJson.fromJson(Map<String, dynamic> json) =>
      _$UserJsonFromJson(json);
}