import '../../domain/entity/track.dart';

import 'loading_bloc.dart';
import 'loading_state.dart';
import 'playlist_event.dart';

typedef PlaylistState = LoadingState<List<TrackMin>>;

class PlaylistBloc extends LoadingBloc<PlaylistEvent, List<TrackMin>> {
  PlaylistBloc(super.repository);

  @override
  Future<List<TrackMin>> fetch(PlaylistEvent event) => repository
      .getPlaylist(event.owner, event.id)
      .then((value) => value.tracks);
}
