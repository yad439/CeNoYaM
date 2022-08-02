import 'album.dart';

class ArtistMin {
  ArtistMin(this._id, this._name);
  final int _id;
  final String _name;

  String get name => _name;

  int get id => _id;
}

class Artist extends ArtistMin {
  Artist(super.id, super.name, this._albums);
  final List<AlbumMin> _albums;

  List<AlbumMin> get albums => _albums;
}
