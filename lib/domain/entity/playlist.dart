import 'user.dart';
import 'track.dart';

class Playlist {
  final User _owner;
  final int _id;
  final List<TrackMin> _tracks;

  Playlist(this._owner, this._id, this._tracks);

  List<TrackMin> get tracks => _tracks;

  int get id => _id;

  User get owner => _owner;
}
