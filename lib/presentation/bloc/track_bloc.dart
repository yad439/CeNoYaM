import '../../domain/entity/track.dart';

import 'loading_bloc.dart';
import 'loading_state.dart';

typedef TrackState = LoadingState<Track>;

class TrackBloc extends LoadingBloc<int, Track> {
  TrackBloc(super.repository);

  @override
  Future<Track> fetch(int event) => repository.getTrack(event);
}
