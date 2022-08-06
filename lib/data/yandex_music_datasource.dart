import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../domain/search_type.dart';
import 'json/album_json.dart';
import 'json/artist_info.dart';
import 'json/download_info.dart';
import 'json/playlist_box.dart';
import 'json/search_response.dart';
import 'json/track_box.dart';

@singleton
class YandexMusicDatasource {
  YandexMusicDatasource(this._dio);

  final Dio _dio;

  Future<DownloadInfo> getDownloadInfo(int trackId) async {
    final infoUrlJsonResponse = await _dio.get<Map<String, dynamic>>(
      '/api/v2.1/handlers/track/$trackId/track/download/m',
      queryParameters: {'hq': '1'},
      options:
          Options(headers: {'X-Retpath-Y': 'https%3A%2F%2Fmusic.yandex.ru%2F'}),
    );

    final infoJson = await _dio.get<Map<String, dynamic>>(
      'https:${infoUrlJsonResponse.data!['src']}&format=json',
    );
    return DownloadInfo.fromJson(infoJson.data!);
  }

  Future<TrackBox> getTrackInfo(int trackId, {int? albumId}) =>
      _dio.get<Map<String, dynamic>>(
        '/handlers/track.jsx',
        queryParameters: {
          'track': albumId == null ? trackId.toString() : '$trackId:$albumId'
        },
      ).then(
        (value) => TrackBox.fromJson(value.data!),
      );

  Future<AlbumJson> getAlbum(int albumId) => _dio.get<Map<String, dynamic>>(
        '/handlers/album.jsx',
        queryParameters: {'album': albumId.toString()},
      ).then(
        (value) => AlbumJson.fromJson(value.data!),
      );

  Future<PlaylistBox> getPlaylist(String owner, int kinds) =>
      _dio.get<Map<String, dynamic>>(
        '/handlers/playlist.jsx',
        queryParameters: {'owner': owner, 'kinds': kinds.toString()},
      ).then((value) => PlaylistBox.fromJson(value.data!));

  Future<ArtistInfo> getArtist(int artistId) => _dio.get<Map<String, dynamic>>(
        '/handlers/artist.jsx',
        queryParameters: {'artist': artistId.toString()},
      ).then((value) => ArtistInfo.fromJson(value.data!));

  Future<Map<String, dynamic>> getProfileInfo() => _dio
      .get<Map<String, dynamic>>('/api/v2.1/handlers/auth')
      .then((value) => value.data!);

  Future<bool> login(String login, String password) => _dio
      .post<String>(
        'https://passport.yandex.ru/auth',
        data: {
          'login': login,
          'passwd': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain,
        ),
      )
      .then(
        (value) => value.data!.contains('data-page-type="profile.passportv2"'),
      );

  Future<void> logout() async {
    final profile = await getProfileInfo();
    await _dio.get<dynamic>(
      'https://passport.yandex.ru/passport',
      queryParameters: {
        'mode': 'embeddedauth',
        'action': 'logut',
        'retpath': 'https://music.yandex.ru',
        'yu': profile['yandexuid'],
        'uid': profile['uid']
      },
    );
  }

  Future<SearchResponse> search(String text, SearchType searchType) =>
      _dio.get<Map<String, dynamic>>(
        '/handlers/music-search.jsx',
        queryParameters: {
          'text': text,
          'type': _searchTypeToString(searchType),
        },
      ).then((value) => SearchResponse.fromJson(value.data!));
}

String _searchTypeToString(SearchType searchType) {
  switch (searchType) {
    case SearchType.all:
      return 'all';
    case SearchType.albums:
      return 'albums';
    case SearchType.artists:
      return 'artists';
    case SearchType.tracks:
      return 'tracks';
    case SearchType.playlists:
      return 'playlists';
  }
}
