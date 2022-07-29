import 'dart:convert';

import 'package:http/http.dart' as http;

import 'json/album_json.dart';
import 'json/artist_info.dart';
import 'json/download_info.dart';
import 'json/playlist_box.dart';
import 'json/track_box.dart';

class YandexMusicDatasource {
  Future<DownloadInfo> getDownloadInfo(int trackId) async {
    final infoUrlJsonResponse = await http.get(
      Uri.https(
        'music.yandex.ru',
        'api/v2.1/handlers/track/$trackId/track/download/m',
        {'hq': '1'},
      ),
      headers: {'X-Retpath-Y': 'https%3A%2F%2Fmusic.yandex.ru%2F'},
    );
    final infoUrlJson = jsonDecode(infoUrlJsonResponse.body);

    final infoJson =
        // ignore: avoid_dynamic_calls
        await http.get(Uri.parse('https:${infoUrlJson['src']}&format=json'));
    return DownloadInfo.fromJson(jsonDecode(infoJson.body));
  }

  Future<TrackBox> getTrackInfo(int trackId, {int? albumId}) => http
      .get(
        Uri.https('music.yandex.ru', 'handlers/track.jsx', {
          'track': albumId == null ? trackId.toString() : '$trackId:$albumId'
        }),
      )
      .then((value) => TrackBox.fromJson(jsonDecode(value.body)));

  Future<AlbumJson> getAlbum(int albumId) => http
      .get(
        Uri.https(
          'music.yandex.ru',
          'handlers/album.jsx',
          {'album': albumId.toString()},
        ),
      )
      .then((value) => AlbumJson.fromJson(jsonDecode(value.body)));

  Future<PlaylistBox> getPlaylist(String owner, int kinds) => http
      .get(
        Uri.https(
          'music.yandex.ru',
          'handlers/playlist.jsx',
          {'owner': owner, 'kinds': kinds.toString()},
        ),
      )
      .then((value) => PlaylistBox.fromJson(jsonDecode(value.body)));

  Future<ArtistInfo> getArtist(int artistId) => http
      .get(
        Uri.https(
          'music.yandex.ru',
          'handlers/artist.jsx',
          {'artist': artistId.toString()},
        ),
      )
      .then((value) => ArtistInfo.fromJson(jsonDecode(value.body)));
}
