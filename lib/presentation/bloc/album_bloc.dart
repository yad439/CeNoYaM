import '../../domain/entity/track.dart';
import 'loading_bloc.dart';
import 'loading_state.dart';

typedef AlbumState = LoadingState<List<TrackMin>>;

class AlbumBloc extends LoadingBloc<int, List<TrackMin>> {
  AlbumBloc(super.repository);

  @override
  Future<List<TrackMin>> fetch(int event) =>
      repository.getAlbum(event).then((album) => album.tracks);
}
