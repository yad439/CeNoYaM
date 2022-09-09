import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/album.dart';
import '../../domain/entity/artist.dart';
import '../../domain/entity/playlist.dart';
import '../../domain/entity/track.dart';
import '../../domain/enum/artist_subcategory.dart';
import '../bloc/album_bloc.dart';
import '../bloc/artist_bloc.dart';
import '../bloc/artist_event.dart';
import '../bloc/artist_state.dart';
import '../bloc/playlist_bloc.dart';
import '../bloc/playlist_event.dart';
import '../bloc/track_bloc.dart';
import '../widget/album_widget.dart';
import '../widget/artist_widget.dart';
import '../widget/playlist_widget.dart';
import '../widget/track_widget.dart';

abstract class ListEntryAdapter<T, EventT, StateT,
    BlocT extends Bloc<EventT, StateT>> {
  String title(T object);
  String subtitle(T object);
  EventT onTapAction(T object);
  Widget screen(BuildContext context, T object);
  String get routeName;
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
  @override
  String get routeName => PlaylistWidget.routeName;
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
  @override
  String get routeName => TrackWidget.routeName;
}

class AlbumEntryAdapter
    implements ListEntryAdapter<AlbumMin, int, AlbumState, AlbumBloc> {
  const AlbumEntryAdapter();
  @override
  String title(AlbumMin object) => object.title;
  @override
  String subtitle(AlbumMin object) => object.artistString;
  @override
  int onTapAction(AlbumMin object) => object.id;
  @override
  Widget screen(BuildContext context, AlbumMin object) => const AlbumWidget();
  @override
  String get routeName => AlbumWidget.routeName;
}

class ArtistEntryAdapter
    implements
        ListEntryAdapter<ArtistMin, ArtistEvent, ArtistState, ArtistBloc> {
  const ArtistEntryAdapter();
  @override
  String title(ArtistMin object) => object.name;
  @override
  String subtitle(ArtistMin object) => '';
  @override
  ArtistEvent onTapAction(ArtistMin object) =>
      ArtistEvent.load(object.id, ArtistSubcategory.albums);
  @override
  Widget screen(BuildContext context, ArtistMin object) => const ArtistWidget();
  @override
  String get routeName => ArtistWidget.routeName;
}
