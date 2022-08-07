import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/music_repository.dart';
import 'loading_state.dart';

abstract class LoadingBloc<EventT, StateT>
    extends Bloc<EventT, LoadingState<StateT>> {
  LoadingBloc(this._repository) : super(const LoadingState.uninitialized()) {
    on<EventT>(_load);
  }
  final MusicRepository _repository;

  MusicRepository get repository => _repository;

  Future<void> _load(EventT event, Emitter<LoadingState<StateT>> emit) async {
    final result = await fetch(event);
    emit(LoadingState.loaded(result));
  }

  Future<StateT> fetch(EventT event);
}
