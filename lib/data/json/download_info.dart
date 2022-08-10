import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_info.freezed.dart';
part 'download_info.g.dart';

@Freezed(equal: true)
class DownloadInfo with _$DownloadInfo {
  const factory DownloadInfo(String host, String path, String s, String ts) =
      _DownloadInfo;

  factory DownloadInfo.fromJson(Map<String, dynamic> json) =>
      _$DownloadInfoFromJson(json);
}
