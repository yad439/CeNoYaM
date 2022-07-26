import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/music_repository.dart';
import 'playlist_event.dart';
import 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final MusicRepository _repository;

  PlaylistBloc(this._repository) : super(PlaylistState.uninitialized()){
    on<PlaylistEvent>((event, emit) async => emit(await event.when(load: _load)));
  }

  Future<PlaylistState> _load(String owner, int id) async {
    final playlist = await _repository.getPlaylist(owner, id);
    return PlaylistState.loaded(playlist.tracks);
  }
}
