import 'package:json_annotation/json_annotation.dart';

part 'user_json.g.dart';

@JsonSerializable(createToJson: false)
class UserJson {
  UserJson(this.uid, this.login);

  factory UserJson.fromJson(Map<String, dynamic> json) =>
      _$UserJsonFromJson(json);
  final int uid;
  final String login;
}
