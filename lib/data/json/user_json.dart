import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_json.freezed.dart';
part 'user_json.g.dart';

@Freezed(equal: true)
class UserJson with _$UserJson {
  const factory UserJson(int uid, String login) = _UserJson;

  factory UserJson.fromJson(Map<String, dynamic> json) =>
      _$UserJsonFromJson(json);
}
