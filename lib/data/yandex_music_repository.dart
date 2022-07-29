import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '/domain/entity/album.dart';
import '/domain/entity/artist.dart';
import '/domain/entity/playlist.dart';
import '/domain/entity/track.dart';
import '/domain/entity/user.dart';
import '/domain/music_repository.dart';
import 'yandex_music_datasource.dart';

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
  Future<Playlist> getPlaylist(String owner, int id) async {
    final playlistJson = await _datasource.getPlaylist(owner, id);
    final playlist = playlistJson.playlist;
    final ownerJson = playlist.owner;
    return Playlist(
      User(ownerJson.uid, ownerJson.login),
      playlist.kind,
      playlist.tracks
          .map(
            (t) => TrackMin.joinArtists(
              int.parse(t.id),
              t.title,
              t.artists.map((e) => e.name),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<Track> getTrack(int trackId, {int? albumId}) async {
    final trackJson = await _datasource.getTrackInfo(trackId, albumId: albumId);
    final track = trackJson.track;
    final album = track.albums[0];
    return Track(
      trackId,
      track.title,
      AlbumMin(album.id, album.title),
      track.artists.map((a) => ArtistMin(a.id, a.name)).toList(growable: false),
    );
  }

  @override
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
          .map(
            (t) => TrackMin.joinArtists(
              int.parse(t.id),
              t.title,
              t.artists.map((e) => e.name),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<Artist> getArtist(int id) async {
    final artistBox = await _datasource.getArtist(id);
    final artistJson = artistBox.artist;
    final albumsJson = artistBox.albums;
    return Artist(
      id,
      artistJson.name,
      albumsJson.map((a) => AlbumMin(a.id, a.title)).toList(growable: false),
    );
  }
}
