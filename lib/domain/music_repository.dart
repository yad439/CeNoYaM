import 'entity/album.dart';
import 'entity/artist.dart';
import 'entity/artist_subcategory.dart';
import 'entity/playlist.dart';
import 'entity/search_results.dart';
import 'entity/search_type.dart';
import 'entity/track.dart';

abstract class MusicRepository {
  Future<Album> getAlbum(int id);

  Future<Artist> getArtist(int id, {ArtistSubcategory? subcategory});

  Future<Uri> getDownloadUrl(int trackId);

  Future<Playlist> getPlaylist(String owner, int id);

  Future<Track> getTrack(int trackId, {int? albumId});

  Future<bool> login(String login, String password);

  Future<void> logout();

  Future<String?> getUsername();

  Future<SearchResults> search(String text, SearchType searchType);
}
