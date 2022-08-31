import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enum/artist_subcategory.dart';
import '../../domain/music_repository.dart';
import 'artist_event.dart';
import 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  ArtistBloc(this._repository) : super(const ArtistState.initial()) {
    on<ArtistEvent>(
      (event, emit) => event.when(
        load: (id, subcategory) => _load(id, subcategory, emit),
        fetchAdditinal: (subcategory) => _fetchAdditional(subcategory, emit),
      ),
      transformer: restartable(),
    );
  }
  final MusicRepository _repository;

  Future<void> _load(
    int id,
    ArtistSubcategory? subcategory,
    Emitter<ArtistState> emit,
  ) async {
    emit(ArtistState.loading(id));
    final result = await _repository.getArtist(id, subcategory: subcategory);
    emit(ArtistState.loaded(result));
  }

  Future<void> _fetchAdditional(
    ArtistSubcategory subcategory,
    Emitter<ArtistState> emit,
  ) async {
    await state.when(
      initial: () {
        assert(false, 'Cannot fetch additional info in initial state');
      },
      loading: (id) async {
        final result =
            await _repository.getArtist(id, subcategory: subcategory);
        emit(ArtistState.loaded(result));
      },
      loaded: (artist) async {
        final result =
            await _repository.getArtist(artist.id, subcategory: subcategory);
        emit(ArtistState.loaded(result));
      },
    );
  }
}
