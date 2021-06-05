import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '/domain/music_repository.dart';
import '/domain/entity/album.dart';
import '/domain/entity/artist.dart';
import '/domain/entity/playlist.dart';
import '/domain/entity/track.dart';
import '/domain/entity/user.dart';
import 'json/download_info.dart';
import 'yandex_music_datasource.dart';

class YandexMusicRepository implements MusicRepository {
  final YandexMusicDatasource _datasource;

  YandexMusicRepository(this._datasource);

  Future<Uri> getDownloadUrl(int trackId) async {
    DownloadInfo info = await _datasource.getDownloadInfo(trackId);

    var output = AccumulatorSink<Digest>();
    var input = md5.startChunkedConversion(output);
    input.add(utf8.encode('XGRlBW9FXlekgbPrRHuSiA'));
    input.add(utf8.encode(info.path.substring(1)));
    input.add(utf8.encode(info.s));
    input.close();
    final digest = output.events.first;

    return Uri.https(info.host, 'get-mp3/$digest/${info.ts}/${info.path}');
  }

  Future<Playlist> getPlaylist(String owner, int id) async {
    final playlistJson = await _datasource.getPlaylist(owner, id);
    var playlist = playlistJson.playlist;
    var ownerJson = playlist.owner;
    return Playlist(
        User(ownerJson.uid, ownerJson.login),
        playlist.kind,
        playlist.tracks
            .map((t) => TrackMin(int.parse(t.id), t.title))
            .toList(growable: false));
  }

  Future<Track> getTrack(int trackId, {int? albumId}) async {
    final trackJson = await _datasource.getTrackInfo(trackId, albumId: albumId);
    var track = trackJson.track;
    var album = track.albums[0];
    return Track(
        trackId,
        track.title,
        AlbumMin(album.id, album.title),
        track.artists
            .map((a) => ArtistMin(a.id, a.name))
            .toList(growable: false));
  }

  Future<Album> getAlbum(int id) async {
    final albumJson = await _datasource.getAlbum(id);
    return Album(
        id,
        albumJson.title,
        albumJson.artists
            .map((a) => ArtistMin(a.id, a.name))
            .toList(growable: false),
        albumJson.volumes
            .expand((e) => e)
            .map((t) => TrackMin(int.parse(t.id), t.title))
            .toList(growable: false));
  }

  Future<Artist> getArtist(int id) async {
    final artistBox = await _datasource.getArtist(id);
    final artistJson = artistBox.artist;
    final albumsJson = artistBox.albums;
    return Artist(id, artistJson.name,
        albumsJson.map((a) => AlbumMin(a.id, a.title)).toList(growable: false));
  }
}
