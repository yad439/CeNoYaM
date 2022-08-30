import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:cenoyam/domain/enum/search_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';

void main() {
  final data = TestData();
  final datasource = YandexMusicDatasource(data.dio);

  group('Get request', () {
    test('returns correct track info', () async {
      final trackBox = await datasource.getTrackInfo(data.trackDto.id);

      expect(trackBox, data.trackBoxDto);
    });

    test('returns correct album', () async {
      final album = await datasource.getAlbum(data.albumDto.id);

      expect(album, data.albumDto);
    });

    test('returns correct playlist', () async {
      final playlistDto = data.playlistBoxDto.playlist;

      final playlistBox = await datasource.getPlaylist(
        playlistDto.owner.login,
        playlistDto.kind,
      );

      expect(playlistBox, data.playlistBoxDto);
    });

    test('returns correct artist', () async {
      final artistBox =
          await datasource.getArtist(data.artistInfoDto.artist.id);

      expect(artistBox, data.artistInfoDto);
    });

    test('returns correct download info', () async {
      final downloadInfo = await datasource.getDownloadInfo(1);

      expect(downloadInfo, data.downloadInfoDto);
    });

    test('returns correct profile info', () async {
      final profileInfo = await datasource.getProfileInfo();

      expect(profileInfo, data.profileInfoJson);
    });
  });

  group('Other request', () {
    test('performs login', () async {
      final result =
          await datasource.login('correct_login', 'correct_password');

      final opts = verify(
        data.dio.post<String>(
          'https://passport.yandex.ru/auth',
          data: {'login': 'correct_login', 'passwd': 'correct_password'},
          options: captureAnyNamed('options'),
        ),
      ).captured.single as Options;
      expect(opts.contentType, Headers.formUrlEncodedContentType);
      expect(opts.responseType, ResponseType.plain);
      expect(result, true);
    });

    test('performs logout', () async {
      await datasource.logout();

      verify(
        data.dio.get<dynamic>(
          'https://passport.yandex.ru/passport',
          queryParameters: {
            'mode': 'embeddedauth',
            'action': 'logut',
            'retpath': 'https://music.yandex.ru',
            'yu': data.profileInfoJson['yandexuid'],
            'uid': data.profileInfoJson['uid']
          },
        ),
      );
    });

    test('performs search', () async {
      final result = await datasource.search('query', SearchType.all);

      expect(result.albums, data.searchResultDto.albums);
      expect(result.artists, data.searchResultDto.artists);
      expect(result.tracks, data.searchResultDto.tracks);
      expect(
        result.playlists.items.length,
        data.searchResultDto.playlists.items.length,
      );
      expect(
        result.playlists.items.first.kind,
        data.searchResultDto.playlists.items.first.kind,
      );
    });
  });
}
