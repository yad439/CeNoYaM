import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'test_data.dart';

void main() {
  final data = TestData();
  final datasource = YandexMusicDatasource(data.dio);

  group('Get request', () {
    test('returns correct track info', () async {
      final trackBox = await datasource.getTrackInfo(data.trackDto.id);
      final track = trackBox.track;

      expect(track.id, data.trackDto.id);
      expect(track.title, data.trackDto.title);
      expect(track.available, data.trackDto.available);
      expect(track.artists.length, data.trackDto.artists.length);
      expect(track.artists.first.id, data.trackDto.artists.first.id);
      expect(track.albums.length, data.trackDto.albums.length);
      expect(track.albums.first.id, data.trackDto.albums.first.id);
    });

    test('returns correct album', () async {
      final album = await datasource.getAlbum(data.albumDto.id);

      expect(album.id, data.albumDto.id);
      expect(album.title, data.albumDto.title);
      expect(album.artists.length, data.albumDto.artists.length);
      expect(album.artists.first.id, data.albumDto.artists.first.id);
      expect(album.volumes.length, data.albumDto.volumes.length);
      expect(album.volumes.first.length, data.albumDto.volumes.first.length);
      expect(
        album.volumes.first.first.id,
        data.albumDto.volumes.first.first.id,
      );
    });

    test('returns correct playlist', () async {
      final playlistDto = data.playlistBoxDto.playlist;

      final playlistBox = await datasource.getPlaylist(
        playlistDto.owner.login,
        playlistDto.kind,
      );
      final playlist = playlistBox.playlist;

      expect(playlist.kind, playlistDto.kind);
      expect(playlist.owner.uid, playlistDto.owner.uid);
      expect(playlist.owner.login, playlistDto.owner.login);
      expect(playlist.title, playlistDto.title);
      expect(playlist.tracks.length, playlistDto.tracks.length);
      expect(playlist.tracks.first.id, playlistDto.tracks.first.id);
    });

    test('returns correct artist', () async {
      final artistDto = data.artistInfoDto.artist;

      final artistBox = await datasource.getArtist(artistDto.id);
      final artist = artistBox.artist;

      expect(artistBox.albums.length, data.artistInfoDto.albums.length);
      expect(artistBox.albums.first.id, data.artistInfoDto.albums.first.id);
      expect(artistBox.trackIds, data.artistInfoDto.trackIds);
      expect(artist.id, artistDto.id);
      expect(artist.name, artistDto.name);
    });

    test('returns correct download info', () async {
      final downloadInfo = await datasource.getDownloadInfo(1);

      expect(downloadInfo.host, data.downloadInfoDto.host);
      expect(downloadInfo.path, data.downloadInfoDto.path);
      expect(downloadInfo.s, data.downloadInfoDto.s);
      expect(downloadInfo.ts, data.downloadInfoDto.ts);
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
  });
}
