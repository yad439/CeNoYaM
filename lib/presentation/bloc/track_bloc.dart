import '../../domain/entity/track.dart';
import 'loading_bloc.dart';

class TrackBloc extends LoadingBloc<int, Track> {
  TrackBloc(super.repository);

  @override
  Future<Track> fetch(int event) => repository.getTrack(event);
}
