import 'album.dart';

class ArtistMin {
  final int _id;
  final String _name;

  ArtistMin(this._id, this._name);

  String get name => _name;

  int get id => _id;
}

class Artist extends ArtistMin {
  final List<AlbumMin> _albums;

  Artist(int id, String name, this._albums) : super(id, name);

  List<AlbumMin> get albums => _albums;
}
