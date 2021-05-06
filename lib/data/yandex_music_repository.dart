import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'download_info.dart';

class YandexMusicRepository {
  Future<Uri> getDownloadUrl(int trackId) async {
    final infoUrlJsonResponse = await http.get(Uri.https('music.yandex.ru',
        'api/v2.1/handlers/track/$trackId/track/download/m?hq=1'));
    final infoUrlJson = jsonDecode(infoUrlJsonResponse.body);

    final infoJson =
        await http.get(Uri.parse(infoUrlJson["src"] + '&format=json'));
    final info = DownloadInfo.fromJson(jsonDecode(infoJson.body));

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
