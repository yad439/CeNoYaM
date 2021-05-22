import 'album.dart';
import 'artist.dart';

class TrackMin {
  final int _id;
  final String _title;

  TrackMin(this._id, this._title);

  String get title => _title;

  int get id => _id;
}

class Track extends TrackMin {
  final AlbumMin _album;
  final List<ArtistMin> _artists;

  Track(int id, String title, this._album, this._artists) : super(id, title);

  List<ArtistMin> get artists => _artists;

  AlbumMin get album => _album;
}
