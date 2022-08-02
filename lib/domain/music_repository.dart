import 'entity/album.dart';
import 'entity/artist.dart';
import 'entity/playlist.dart';
import 'entity/search_results.dart';
import 'entity/track.dart';
import 'search_type.dart';

abstract class MusicRepository {
  Future<Album> getAlbum(int id);

  Future<Artist> getArtist(int id);

  Future<Uri> getDownloadUrl(int trackId);

  Future<Playlist> getPlaylist(String owner, int id);

  Future<Track> getTrack(int trackId, {int? albumId});

  Future<bool> login(String login, String password);

  Future<void> logout();

  Future<SearchResults> search(String text, SearchType searchType);
}
