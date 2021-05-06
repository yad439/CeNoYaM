import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'yandex_music_datasource.dart';
import 'download_info.dart';

class YandexMusicRepository {
  final YandexMusicDatasource _datasource;

  YandexMusicRepository(this._datasource);

  Future<Uri> getDownloadUrl(int trackId) async {
    DownloadInfo info = await _datasource.getDownloadInfo(trackId);

    var output = AccumulatorSink<Digest>();
    var input = md5.startChunkedConversion(output);
    input.add(utf8.encode('XGRlBW9FXlekgbPrRHuSiA'));
    input.add(utf8.encode(info.path.substring(1)));
    input.add(utf8.encode(info.s));
    input.close();
    final digest = output.events.first;

    return Uri.https(info.host, 'get-mp3/$digest/${info.ts}/${info.path}');
  }
}
