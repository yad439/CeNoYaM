import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/album.dart';
import '../../domain/entity/playlist.dart';
import '../../domain/entity/track.dart';
import '../bloc/album_bloc.dart';
import '../bloc/loading_state.dart';
import '../bloc/playlist_bloc.dart';
import '../bloc/playlist_event.dart';
import '../bloc/track_bloc.dart';
import '../widget/album_widget.dart';
import '../widget/playlist_widget.dart';
import '../widget/track_widget.dart';

abstract class ListEntryAdapter<T, EventT, StateT,
    BlocT extends Bloc<EventT, StateT>> {
  String title(T object);
  String subtitle(T object);
  EventT onTapAction(T object);
  Widget screen(BuildContext context, T object);
}

class PlaylistEntryAdapter
    implements
        ListEntryAdapter<PlaylistMin, PlaylistEvent, PlaylistState,
            PlaylistBloc> {
  const PlaylistEntryAdapter();
  @override
  String title(PlaylistMin object) => object.title;
  @override
  String subtitle(PlaylistMin object) => object.owner.login;
  @override
  PlaylistEvent onTapAction(PlaylistMin object) =>
      PlaylistEvent.load(object.owner.login, object.id);
  @override
  Widget screen(BuildContext context, PlaylistMin object) =>
      const PlaylistWidget();
}

class TrackEntryAdapter
    implements ListEntryAdapter<TrackMin, int, TrackState, TrackBloc> {
  const TrackEntryAdapter();
  @override
  String title(TrackMin object) => object.title;
  @override
  String subtitle(TrackMin object) => object.artistString;
  @override
  int onTapAction(TrackMin object) => object.id;
  @override
  Widget screen(BuildContext context, TrackMin object) => const TrackWidget();
}

class AlbumEntryAdapter
    implements
        ListEntryAdapter<AlbumMin, int, LoadingState<List<TrackMin>>,
            AlbumBloc> {
  const AlbumEntryAdapter();
  @override
  String title(AlbumMin object) => object.title;
  @override
  String subtitle(AlbumMin object) => object.artistString;
  @override
  int onTapAction(AlbumMin object) => object.id;
  @override
  Widget screen(BuildContext context, AlbumMin object) => const AlbumWidget();
}
