import 'artist.dart';
import 'track.dart';

class AlbumMin {
  AlbumMin(this._id, this._title);
  final int _id;
  final String _title;

  String get title => _title;

  int get id => _id;
}

class Album extends AlbumMin {
  Album(super.id, super.title, this._artists, this._tracks);
  final List<ArtistMin> _artists;
  final List<TrackMin> _tracks;

  List<TrackMin> get tracks => _tracks;

  List<ArtistMin> get artists => _artists;
}
