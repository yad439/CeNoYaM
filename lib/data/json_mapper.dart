import '../domain/entity/album.dart';
import '../domain/entity/artist.dart';
import '../domain/entity/playlist.dart';
import '../domain/entity/track.dart';
import '../domain/entity/user.dart';
import '../domain/util.dart';
import 'json/album_json.dart';
import 'json/artist_info.dart';
import 'json/artist_json.dart';
import 'json/playlist_json.dart';
import 'json/track_json.dart';
import 'json/user_json.dart';

class JsonMapper {
  TrackMin trackMinFromJson(TrackJson json) => TrackMin(
        json.id,
        json.title,
        json.available,
        generateArtistString(json.artists.map((e) => e.name)),
      );
  Track trackFromJson(TrackJson json) => Track(
        json.id,
        json.title,
        json.available,
        json.albums.map(albumMinFromJson).toList(growable: false),
        json.artists.map(artistMinFromJson).toList(growable: false),
      );
  ArtistMin artistMinFromJson(ArtistJson json) => ArtistMin(
        json.id,
        json.name,
      );
  Artist artistFromJson(ArtistInfo json) => Artist(
        json.artist.id,
        json.artist.name,
        json.albums.map(albumMinFromJson).toList(growable: false),
        json.tracks.map(trackMinFromJson).toList(growable: false),
      );
  AlbumMin albumMinFromJson(AlbumMinJson json) => AlbumMin(
        json.id,
        json.title,
        generateArtistString(json.artists.map((e) => e.name)),
      );
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
