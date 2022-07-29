import 'album.dart';

class ArtistMin {
  ArtistMin(this._id, this._name);
  final int _id;
  final String _name;

  String get name => _name;

  int get id => _id;
}

class Artist extends ArtistMin {
  Artist(int id, String name, this._albums) : super(id, name);
  final List<AlbumMin> _albums;

  List<AlbumMin> get albums => _albums;
}
