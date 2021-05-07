import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:cenoyam/data/yandex_music_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('should return valid link', () async {
    final repo = YandexMusicRepository(YandexMusicDatasource());
    final url = await repo.getDownloadUrl(5493020);
    final resp = await http.get(url);
    expect(resp.statusCode, 200);
    expect(resp.contentLength, greaterThan(0));
  });
}
