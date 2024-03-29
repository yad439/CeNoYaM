import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';

import '/domain/entity/album.dart';
import '/domain/entity/artist.dart';
import '/domain/entity/playlist.dart';
import '/domain/entity/track.dart';
import '/domain/music_repository.dart';
import '../domain/entity/search_results.dart';
import '../domain/enum/artist_subcategory.dart';
import '../domain/enum/search_type.dart';
import 'json_mapper.dart';
import 'yandex_music_datasource.dart';

@Singleton(as: MusicRepository)
class YandexMusicRepository implements MusicRepository {
  YandexMusicRepository(this._datasource);
  final YandexMusicDatasource _datasource;

  @override
  Future<Uri> getDownloadUrl(int trackId) async {
    final info = await _datasource.getDownloadInfo(trackId);

    final output = AccumulatorSink<Digest>();
    md5.startChunkedConversion(output)
      ..add(utf8.encode('XGRlBW9FXlekgbPrRHuSiA'))
      ..add(utf8.encode(info.path.substring(1)))
      ..add(utf8.encode(info.s))
      ..close();
    final digest = output.events.first;

    return Uri.https(info.host, 'get-mp3/$digest/${info.ts}/${info.path}');
  }

  @override
  Future<Playlist> getPlaylist(String owner, int id) => _datasource
      .getPlaylist(owner, id)
      .then((value) => playlistFromJson(value.playlist));

  @override
  Future<Track> getTrack(int trackId, {int? albumId}) => _datasource
      .getTrackInfo(trackId, albumId: albumId)
      .then((value) => trackFromJson(value.track));

  @override
  Future<Album> getAlbum(int id) =>
      _datasource.getAlbum(id).then(albumFromJson);

  @override
  Future<Artist> getArtist(int id, {ArtistSubcategory? subcategory}) =>
      _datasource.getArtist(id, subcategory: subcategory).then(artistFromJson);

  @override
  Future<bool> login(String login, String password) =>
      _datasource.login(login, password);

  @override
  Future<void> logout() => _datasource.logout();

  @override
  Future<String?> getUsername() async {
    final profile = await _datasource.getProfileInfo();
    return profile['logged'] as bool ? profile['login'] as String : null;
  }

  @override
  Future<SearchResults> search(String text, SearchType searchType) async {
    final results = await _datasource.search(text, searchType);
    return SearchResults(
      results.tracks.items.map(trackMinFromJson).toList(growable: false),
      results.artists.items.map(artistMinFromJson).toList(growable: false),
      results.albums.items.map(albumMinFromJson).toList(growable: false),
      results.playlists.items.map(playlistMinFromJson).toList(growable: false),
    );
  }
}
