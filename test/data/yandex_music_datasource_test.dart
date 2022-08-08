import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Dio])
import 'yandex_music_datasource_test.mocks.dart';

void main() {
  final dio = MockDio();
  final datasource = YandexMusicDatasource(dio);

  group('Get request', () {
    const artistJson = {'id': 4, 'name': 'artist name'};
    const artistJson2 = {'id': 5, 'name': 'artist name 2'};
    final albumJson = {
      'id': 6,
      'title': 'album title',
      'artists': [artistJson, artistJson2],
    };
    const albumJson2 = {
      'id': 7,
      'title': 'album title 2',
      'artists': [artistJson2]
    };
    final trackJson = {
      'id': 1,
      'title': 'track title',
      'available': true,
      'artists': [artistJson],
      'albums': [albumJson]
    };
    const trackJson2 = {
      'id': 2,
      'title': 'track title 2',
      'available': true,
      'artists': [artistJson2],
      'albums': [albumJson2]
    };
    final trackJson3 = {
      'id': 3,
      'title': 'track title 3',
      'available': false,
      'artists': [artistJson, artistJson2],
      'albums': [albumJson, albumJson2]
    };

    albumJson['volumes'] = [
      [trackJson, trackJson2],
      [trackJson3]
    ];

    const userJson = {'uid': 8, 'login': 'user_login'};
    final playlistJson = {
      'kind': 9,
      'owner': userJson,
      'title': 'playlist title',
      'tracks': [trackJson, trackJson2, trackJson3]
    };

    test('returns correct track info', () async {
      final trackBoxJson = {'track': trackJson3};
      when(
        dio.get<Map<String, dynamic>>(
          '/handlers/track.jsx',
          queryParameters: {'track': trackJson3['id'].toString()},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: trackBoxJson,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final trackBox = await datasource.getTrackInfo(trackJson3['id']! as int);
      final track = trackBox.track;

      expect(track.id, trackJson3['id']);
      expect(track.title, trackJson3['title']);
      expect(track.available, trackJson3['available']);
      expect(track.artists.length, 2);
      expect(track.artists.first.id, artistJson['id']);
      expect(track.albums.length, 2);
      expect(track.albums.first.id, albumJson['id']);
    });

    test('returns correct album', () async {
      when(
        dio.get<Map<String, dynamic>>(
          '/handlers/album.jsx',
          queryParameters: {'album': albumJson['id'].toString()},
        ),
      ).thenAnswer(
        (_) async =>
            Response(data: albumJson, requestOptions: RequestOptions(path: '')),
      );

      final album = await datasource.getAlbum(albumJson['id']! as int);

      expect(album.id, albumJson['id']);
      expect(album.title, albumJson['title']);
      expect(album.artists.length, 2);
      expect(album.artists.first.id, artistJson['id']);
      expect(album.volumes.length, 2);
      expect(album.volumes.first.length, 2);
      expect(album.volumes.first.first.id, trackJson['id']);
    });

    test('returns correct playlist', () async {
      final playlistBoxJson = {'playlist': playlistJson};
      when(
        dio.get<Map<String, dynamic>>(
          '/handlers/playlist.jsx',
          queryParameters: {
            'owner': userJson['login'],
            'kinds': playlistJson['kind'].toString()
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          data: playlistBoxJson,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final playlistBox = await datasource.getPlaylist(
        userJson['login']! as String,
        playlistJson['kind']! as int,
      );
      final playlist = playlistBox.playlist;

      expect(playlist.kind, playlistJson['kind']);
      expect(playlist.owner.uid, userJson['uid']);
      expect(playlist.owner.login, userJson['login']);
      expect(playlist.title, playlistJson['title']);
      expect(playlist.tracks.length, 3);
      expect(playlist.tracks.first.id, trackJson['id']);
    });

    test('returns correct artist', () async {
      const ids = ['15', '42', '27'];
      final artistBoxJson = {
        'artist': {...artistJson, 'id': artistJson['id'].toString()},
        'albums': [albumJson, albumJson2],
        'trackIds': ids
      };
      when(
        dio.get<Map<String, dynamic>>(
          '/handlers/artist.jsx',
          queryParameters: {'artist': artistJson['id'].toString()},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: artistBoxJson,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final artistBox = await datasource.getArtist(artistJson['id']! as int);
      final artist = artistBox.artist;

      expect(artistBox.albums.length, 2);
      expect(artistBox.albums.first.id, albumJson['id']);
      expect(artistBox.trackIds, ids);
      expect(artist.id, artistJson['id']);
      expect(artist.name, artistJson['name']);
    });

    test('returns correct download info', () async {
      const src = '//example.com/download';
      const info0 = {'src': src};
      const id = 87;
      const info = {
        'host': 'download.test.com',
        'path': '/something/abc',
        's': 'qwer',
        'ts': 'vhgy'
      };
      when(
        dio.get<Map<String, dynamic>>(
          '/api/v2.1/handlers/track/$id/track/download/m',
          queryParameters: {'hq': '1'},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: info0,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      when(dio.get<Map<String, dynamic>>('https:$src&format=json')).thenAnswer(
        (_) async => Response(
          data: info,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final downloadInfo = await datasource.getDownloadInfo(id);

      expect(downloadInfo.host, info['host']);
      expect(downloadInfo.path, info['path']);
      expect(downloadInfo.s, info['s']);
      expect(downloadInfo.ts, info['ts']);
    });

    test('returns correct profile info', () async {
      const info = {'yandexuid': '5734765247', 'uid': '82656'};
      when(dio.get<Map<String, dynamic>>('/api/v2.1/handlers/auth')).thenAnswer(
        (_) async => Response(
          data: info,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final profileInfo = await datasource.getProfileInfo();

      expect(profileInfo, info);
    });
  });

  group('Other request', () {
    test('performs login', () async {
      const login = 'login';
      const password = 'password';
      when(
        dio.post<String>(
          'https://passport.yandex.ru/auth',
          data: {'login': login, 'passwd': password},
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data:
              '<!doctype html><html lang="ru" dir="ltr" data-page-type="profile.passportv2" class="is-js_no"><head><title>Яндекс ID</title><meta charSet="utf-8"/><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7,IE=edge"/><link rel="preload" as="style" ',
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await datasource.login(login, password);

      final opts = verify(
        dio.post<String>(
          'https://passport.yandex.ru/auth',
          data: {'login': login, 'passwd': password},
          options: captureAnyNamed('options'),
        ),
      ).captured.single as Options;
      expect(opts.contentType, Headers.formUrlEncodedContentType);
      expect(opts.responseType, ResponseType.plain);
      expect(result, true);
    });

    test('performs logout', () async {
      const profile = {'yandexuid': '5734765247', 'uid': '82656'};
      when(dio.get<Map<String, dynamic>>('/api/v2.1/handlers/auth')).thenAnswer(
        (_) async => Response(
          data: profile,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      when(
        dio.get<dynamic>(
          'https://passport.yandex.ru/passport',
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: '',
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await datasource.logout();

      verify(
        dio.get<dynamic>(
          'https://passport.yandex.ru/passport',
          queryParameters: {
            'mode': 'embeddedauth',
            'action': 'logut',
            'retpath': 'https://music.yandex.ru',
            'yu': profile['yandexuid'],
            'uid': profile['uid']
          },
        ),
      );
    });
  });
}
