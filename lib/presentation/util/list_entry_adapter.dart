import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/playlist.dart';
import '../bloc/playlist_bloc.dart';
import '../bloc/playlist_event.dart';
import '../bloc/playlist_state.dart';
import '../widget/playlist_widget.dart';

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
