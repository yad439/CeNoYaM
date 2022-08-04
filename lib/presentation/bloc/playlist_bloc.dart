import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/music_repository.dart';
import 'loading_state.dart';
import 'playlist_event.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc(this._repository) : super(const PlaylistState.uninitialized()) {
    on<LoadPlaylist>((event, emit) => _load(event.owner, event.id, emit));
  }
  final MusicRepository _repository;

  Future<void> _load(String owner, int id, Emitter<PlaylistState> emit) async {
    final playlist = await _repository.getPlaylist(owner, id);
    emit(PlaylistState.loaded(playlist.tracks));
  }
}
