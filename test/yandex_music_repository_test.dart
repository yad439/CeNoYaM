import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:cenoyam/data/yandex_music_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should return valid link', () async {
    final repo = YandexMusicRepository(YandexMusicDatasource(Dio(BaseOptions(baseUrl: 'https://music.yandex.ru/'))));
    final url = await repo.getDownloadUrl(5493020);
    final resp = await Dio().get<List<int>>(url.toString());
    expect(resp.statusCode, 200);
    expect(resp.data!.length, greaterThan(0));
  });
}
