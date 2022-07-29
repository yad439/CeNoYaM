import 'track.dart';
import 'user.dart';

class Playlist {
  Playlist(this._owner, this._id, this._tracks);
  final User _owner;
  final int _id;
  final List<TrackMin> _tracks;

  List<TrackMin> get tracks => _tracks;

  int get id => _id;

  User get owner => _owner;
}
