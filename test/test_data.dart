import 'package:cenoyam/data/json/album_json.dart';
import 'package:cenoyam/data/json/artist_info.dart';
import 'package:cenoyam/data/json/artist_json.dart';
import 'package:cenoyam/data/json/download_info.dart';
import 'package:cenoyam/data/json/playlist_box.dart';
import 'package:cenoyam/data/json/playlist_json.dart';
import 'package:cenoyam/data/json/search_response.dart';
import 'package:cenoyam/data/json/track_box.dart';
import 'package:cenoyam/data/json/track_json.dart';
import 'package:cenoyam/data/json/user_json.dart';
import 'package:cenoyam/domain/entity/album.dart';
import 'package:cenoyam/domain/entity/artist.dart';
import 'package:cenoyam/domain/entity/playlist.dart';
import 'package:cenoyam/domain/entity/search_results.dart';
import 'package:cenoyam/domain/entity/track.dart';
import 'package:cenoyam/domain/entity/user.dart';
import 'package:dio/dio.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Dio])
import 'test_data.mocks.dart';

class TestData {
  TestData() {
    const artistJson = {'id': '4', 'name': 'artist name'};
    const artistInt = {'id': 4, 'name': 'artist name'};
    // const artistJson2 = {'id': '5', 'name': 'artist name 2'};
    const artistInt2 = {'id': 5, 'name': 'artist name 2'};
    const artistDto = ArtistJson(4, 'artist name');
    const artistDto2 = ArtistJson(5, 'artist name 2');

    albumJson = {
      'id': 6,
      'title': 'album title',
      'artists': [artistInt, artistInt2],
    };
    const albumJson2 = {
      'id': 7,
      'title': 'album title 2',
      'artists': [artistInt2]
    };
    const albumMinDto = AlbumMinJson(6, 'album title', [artistDto, artistDto2]);
    const albumMinDto2 = AlbumMinJson(7, 'album title 2', [artistDto2]);
    const albumMinEntity2 = AlbumMin(7, 'album title 2', 'artist name 2');

    final trackJson = {
      'id': '1',
      'title': 'track title',
      'available': true,
      'artists': [artistInt],
      'albums': [albumJson]
    };
    const unavailableTrackJson = {
      'id': '2',
      'title': 'track title 2',
      'available': false,
      'artists': <Map<String, Object>>[],
      'albums': <Map<String, Object>>[]
    };
    final trackWithMultipleArtistsJson = {
      'id': '3',
      'title': 'track title 3',
      'available': true,
      'artists': [artistInt, artistInt2],
      'albums': [albumJson, albumJson2]
    };
    trackDto =
        const TrackJson(1, 'track title', true, [artistDto], [albumMinDto]);
    unavailableTrackDto = const TrackJson(2, 'track title 2', false, [], []);
    trackWithMultipleArtistsDto = const TrackJson(
      3,
      'track title 3',
      true,
      [artistDto, artistDto2],
      [albumMinDto, albumMinDto2],
    );
    trackEntity = const Track(
      1,
      'track title',
      true,
      [AlbumMin(6, 'album title', 'artist name; artist name 2')],
      [ArtistMin(4, 'artist name')],
    );
    unavailableTrackEntity = const Track(
      2,
      'track title 2',
      false,
      [],
      [],
    );
    trackWithMultipleArtistsEntity = const Track(
      3,
      'track title 3',
      true,
      [
        AlbumMin(6, 'album title', 'artist name; artist name 2'),
        AlbumMin(7, 'album title 2', 'artist name 2')
      ],
      [ArtistMin(4, 'artist name'), ArtistMin(5, 'artist name 2')],
    );

    trackBoxJson = {'track': trackJson};
    unavailableTrackBoxJson = const {'track': unavailableTrackJson};
    trackWithMultipleArtistsBoxJson = {'track': trackWithMultipleArtistsJson};
    trackBoxDto = TrackBox(trackDto);
    unavailableTrackBoxDto = TrackBox(unavailableTrackDto);
    trackWithMultipleArtistsBoxDto = TrackBox(trackWithMultipleArtistsDto);

    albumJson['volumes'] = [
      [trackJson, unavailableTrackJson],
      [trackWithMultipleArtistsJson]
    ];
    albumDto = AlbumJson(6, 'album title', [
      artistDto,
      artistDto2
    ], [
      [trackDto, unavailableTrackDto],
      [trackWithMultipleArtistsDto]
    ]);
    albumEntity = Album(
      6,
      'album title',
      const [ArtistMin(4, 'artist name'), ArtistMin(5, 'artist name 2')],
      [trackEntity, unavailableTrackEntity, trackWithMultipleArtistsEntity],
    );

    artistBoxJson = {
      'artist': artistJson,
      'albums': [albumJson, albumJson2],
      'tracks': [trackJson, trackWithMultipleArtistsJson, unavailableTrackJson]
    };
    artistInfoDto = ArtistInfo(
      artistDto,
      [albumMinDto, albumMinDto2],
      [trackDto, trackWithMultipleArtistsDto, unavailableTrackDto],
    );
    artistEntity = Artist(
      6,
      'artist name',
      [albumEntity, albumMinEntity2],
      [trackEntity, trackWithMultipleArtistsEntity, unavailableTrackEntity],
    );

    userJson = {'uid': 8, 'login': 'user_login'};
    final playlistJson = {
      'kind': 9,
      'owner': userJson,
      'title': 'playlist title',
      'tracks': [trackJson, unavailableTrackJson, trackWithMultipleArtistsJson]
    };
    playlistBoxJson = {'playlist': playlistJson};
    playlistBoxDto = PlaylistBox(
      PlaylistJson(
        9,
        'playlist title',
        const UserJson(8, 'user_login'),
        [trackDto, unavailableTrackDto, trackWithMultipleArtistsDto],
      ),
    );
    playlistEntity = Playlist(
      User(8, 'user_login'),
      9,
      'playlist title',
      [trackEntity, unavailableTrackEntity, trackWithMultipleArtistsEntity],
    );

    downloadPreInfoJson = const {'src': '//example.com/download?ts=123'};
    downloadInfoJson = const {
      'host': 'download.test.com',
      'path': '/something/abc',
      's': 'qwer',
      'ts': 'asdf'
    };
    downloadInfoDto = const DownloadInfo(
      'download.test.com',
      '/something/abc',
      'qwer',
      'asdf',
    );

    profileInfoJson = const {
      'logged': true,
      'login': 'some_login',
      'yandexuid': '5734765247',
      'uid': '82656'
    };
    anonymousProfileInfoJson = const {
      'logged': false,
      'yandexuid': '9874622624',
      'uid': 0
    };

    searchResultsJson = {
      'text': 'query',
      'albums': {
        'items': [albumJson, albumJson2]
      },
      'artists': {
        'items': [artistInt, artistInt2]
      },
      'tracks': {
        'items': [
          {...trackJson, 'id': 1},
          {...unavailableTrackJson, 'id': 2},
          {...trackWithMultipleArtistsJson, 'id': 3}
        ]
      },
      'playlists': {
        'items': [playlistJson]
      }
    };
    searchResultDto = SearchResponse(
      const SearchEntry<AlbumMinJson>([albumMinDto, albumMinDto2]),
      SearchEntry<TrackJson>(
        [trackDto, unavailableTrackDto, trackWithMultipleArtistsDto],
      ),
      const SearchEntry<ArtistJson>([artistDto, artistDto2]),
      SearchEntry<PlaylistJson>([playlistBoxDto.playlist]),
    );
    searchResultsEntity = SearchResults(
      [trackEntity, unavailableTrackEntity, trackWithMultipleArtistsEntity],
      [artistEntity, artistEntity],
      [
        albumEntity,
        const AlbumMin(7, 'album title 2', 'artist name; artist name 2')
      ],
      [playlistEntity],
    );

    dio = MockDio();
    when(
      dio.get<Map<String, dynamic>>(
        '/handlers/track.jsx',
        queryParameters: {'track': trackJson['id']},
      ),
    ).thenAnswer(
      (_) async => Response(
        data: trackBoxJson,
        requestOptions: RequestOptions(path: ''),
      ),
    );
    when(
      dio.get<Map<String, dynamic>>(
        '/handlers/album.jsx',
        queryParameters: {'album': albumJson['id'].toString()},
      ),
    ).thenAnswer(
      (_) async =>
          Response(data: albumJson, requestOptions: RequestOptions(path: '')),
    );
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
    when(
      dio.get<Map<String, dynamic>>(
        '/handlers/artist.jsx',
        queryParameters: {'artist': artistJson['id']},
      ),
    ).thenAnswer(
      (_) async => Response(
        data: artistBoxJson,
        requestOptions: RequestOptions(path: ''),
      ),
    );
    when(
      dio.get<Map<String, dynamic>>(
        '/api/v2.1/handlers/track/1/track/download/m',
        queryParameters: anyNamed('queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: downloadPreInfoJson,
        requestOptions: RequestOptions(path: ''),
      ),
    );
    when(
      dio.get<Map<String, dynamic>>(
        'https://example.com/download?ts=123&format=json',
      ),
    ).thenAnswer(
      (_) async => Response(
        data: downloadInfoJson,
        requestOptions: RequestOptions(path: ''),
      ),
    );
    when(dio.get<Map<String, dynamic>>('/api/v2.1/handlers/auth')).thenAnswer(
      (_) async => Response(
        data: profileInfoJson,
        requestOptions: RequestOptions(path: ''),
      ),
    );
    when(
      dio.post<String>(
        'https://passport.yandex.ru/auth',
        data: const {'login': 'correct_login', 'passwd': 'correct_password'},
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: correctLoginResopnse,
        requestOptions: RequestOptions(path: ''),
      ),
    );
    when(
      dio.post<String>(
        'https://passport.yandex.ru/auth',
        data: const {'login': 'correct_login', 'passwd': 'wrong_password'},
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: incorrectLoginResopnse,
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
    when(
      dio.get<Map<String, dynamic>>(
        '/handlers/music-search.jsx',
        queryParameters: {
          'text': 'query',
          'type': 'all',
        },
      ),
    ).thenAnswer(
      (_) async => Response(
        data: searchResultsJson,
        requestOptions: RequestOptions(path: ''),
      ),
    );
  }

  late final Dio dio;

  late final Map<String, dynamic> trackBoxJson;
  late final Map<String, dynamic> unavailableTrackBoxJson;
  late final Map<String, dynamic> trackWithMultipleArtistsBoxJson;
  late final Map<String, dynamic> artistBoxJson;
  late final Map<String, dynamic> albumJson;
  late final Map<String, dynamic> userJson;
  late final Map<String, dynamic> playlistBoxJson;
  late final Map<String, dynamic> downloadPreInfoJson;
  late final Map<String, dynamic> downloadInfoJson;
  late final Map<String, dynamic> profileInfoJson;
  late final Map<String, dynamic> anonymousProfileInfoJson;
  late final Map<String, dynamic> searchResultsJson;

  late final TrackJson trackDto;
  late final TrackJson unavailableTrackDto;
  late final TrackJson trackWithMultipleArtistsDto;
  late final TrackBox trackBoxDto;
  late final TrackBox unavailableTrackBoxDto;
  late final TrackBox trackWithMultipleArtistsBoxDto;
  late final ArtistInfo artistInfoDto;
  late final AlbumJson albumDto;
  late final PlaylistBox playlistBoxDto;
  late final DownloadInfo downloadInfoDto;
  late final SearchResponse searchResultDto;

  late final Track trackEntity;
  late final Track unavailableTrackEntity;
  late final Track trackWithMultipleArtistsEntity;
  late final Artist artistEntity;
  late final Album albumEntity;
  late final Playlist playlistEntity;
  late final SearchResults searchResultsEntity;

  late final String correctLoginResopnse =
      '<!doctype html><html lang="ru" dir="ltr" data-page-type="profile.passportv2" class="is-js_no"><head><title>Яндекс ID</title>';
  late final String incorrectLoginResopnse =
      '<!doctype html><html lang="ru" data-page-type="auth.enter" class="is-js_no"><head><meta charset="utf-8"/><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7,IE=edge"/><link rel="shortcut icon" href="/favicon.ico"/><title>Авторизация</title>';
}
