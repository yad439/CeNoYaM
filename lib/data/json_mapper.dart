import '../domain/entity/album.dart';
import '../domain/entity/artist.dart';
import '../domain/entity/playlist.dart';
import '../domain/entity/track.dart';
import '../domain/entity/user.dart';
import 'json/album_json.dart';
import 'json/artist_info.dart';
import 'json/artist_json.dart';
import 'json/playlist_json.dart';
import 'json/track_json.dart';
import 'json/user_json.dart';

class JsonMapper {
  TrackMin trackMinFromJson(TrackJson json) => TrackMin(
        int.parse(json.id),
        json.title,
        json.artists.map((e) => e.name).join('; '),
      );
  Track trackFromJson(TrackJson json) => Track(
        int.parse(json.id),
        json.title,
        albumMinFromJson(json.albums.first),
        json.artists.map(artistMinFromJson).toList(growable: false),
      );
  ArtistMin artistMinFromJson(ArtistMinJson json) => ArtistMin(
        json.id,
        json.name,
      );
  Artist artistFromJson(ArtistInfo json) => Artist(
        json.artist.id,
        json.artist.name,
        json.albums.map(albumMinFromJson).toList(growable: false),
      );
  AlbumMin albumMinFromJson(AlbumMinJson json) => AlbumMin(json.id, json.title);
  Album albumFromJson(AlbumJson json) => Album(
        json.id,
        json.title,
        json.artists.map(artistMinFromJson).toList(growable: false),
        json.volumes
            .expand((e) => e)
            .map(trackMinFromJson)
            .toList(growable: false),
      );
  PlaylistMin playlistMinFromJson(PlaylistMinJson json) => PlaylistMin(
        userFromJson(json.owner),
        json.kind,
        json.title,
      );
  Playlist playlistFromJson(PlaylistJson json) => Playlist(
        userFromJson(json.owner),
        json.kind,
        json.title,
        json.tracks.map(trackFromJson).toList(growable: false),
      );
  User userFromJson(UserJson json) => User(
        json.uid,
        json.login,
      );
}
