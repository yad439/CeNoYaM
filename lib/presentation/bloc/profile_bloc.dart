import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/music_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repository) : super(const ProfileState.unknown()) {
    on<ProfileEvent>(
      (event, emit) {
        assert(event == ProfileEvent.update, 'Unexpected event');
        return _update(emit);
      },
      transformer: droppable(),
    );
  }
  final MusicRepository _repository;

  Future<void> _update(Emitter<ProfileState> emit) async {
    final username = await _repository.getUsername();
    if (username == null) {
      emit(const ProfileState.anonimous());
    } else {
      emit(ProfileState.loggedIn(username));
    }
  }
}
