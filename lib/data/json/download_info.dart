import 'package:json_annotation/json_annotation.dart';

part 'download_info.g.dart';

@JsonSerializable(createToJson: false)
class DownloadInfo {
  final String host;
  final String path;
  final String s;
  final String ts;

  DownloadInfo(this.host, this.path, this.s, this.ts);

  factory DownloadInfo.fromJson(Map<String, dynamic> json) =>
      _$DownloadInfoFromJson(json);
}
