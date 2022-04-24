import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/music_repository.dart';
import 'playlist_event.dart';
import 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final MusicRepository _repository;

  PlaylistBloc(this._repository) : super(PlaylistState.uninitialized());

  @override
  Stream<PlaylistState> mapEventToState(PlaylistEvent event) {
    return event.when(load: _load);
  }

  Stream<PlaylistState> _load(String owner, int id) async* {
    final playlist = await _repository.getPlaylist(owner, id);
    yield PlaylistState.loaded(playlist.tracks);
  }
}
