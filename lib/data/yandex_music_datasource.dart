import 'dart:convert';

import 'package:http/http.dart' as http;

import 'json/download_info.dart';

class YandexMusicDatasource {
  Future<DownloadInfo> getDownloadInfo(int trackId) async {
    final infoUrlJsonResponse = await http.get(
        Uri.https('music.yandex.ru',
            'api/v2.1/handlers/track/$trackId/track/download/m', {'hq': '1'}),
        headers: {'X-Retpath-Y': 'https%3A%2F%2Fmusic.yandex.ru%2F'});
    final infoUrlJson = jsonDecode(infoUrlJsonResponse.body);

    final infoJson = await http
        .get(Uri.parse('https:' + infoUrlJson["src"] + '&format=json'));
    return DownloadInfo.fromJson(jsonDecode(infoJson.body));
  }
}
