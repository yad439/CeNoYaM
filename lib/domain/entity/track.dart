import 'album.dart';
import 'artist.dart';

class TrackMin {
  TrackMin(this._id, this._title, this._artistString);

  TrackMin.joinArtists(this._id, this._title, Iterable<String> artists)
      : _artistString = artists.join(';');
  final int _id;
  final String _title;
  final String _artistString;

  String get title => _title;

  String get artistString => _artistString;

  int get id => _id;
}

class Track extends TrackMin {
  Track(int id, String title, this._album, this._artists)
      : super.joinArtists(id, title, _artists.map((a) => a.name));
  final AlbumMin _album;
  final List<ArtistMin> _artists;

  List<ArtistMin> get artists => _artists;

  AlbumMin get album => _album;
}
