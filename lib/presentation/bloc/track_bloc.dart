import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/track.dart';
import '../../domain/music_repository.dart';
import 'loading_state.dart';

class TrackBloc extends Bloc<int, LoadingState<Track>> {
  TrackBloc(this._repository) : super(const LoadingState.uninitialized()) {
    on<int>(_load);
  }
  final MusicRepository _repository;

  Future<void> _load(int id, Emitter<LoadingState<Track>> emit) async {
    emit(LoadingState.loaded(await _repository.getTrack(id)));
  }
}
