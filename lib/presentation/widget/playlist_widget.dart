import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/playlist_bloc.dart';
import 'track_entry_widget.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({super.key});

  static const routeName = '/playlist';

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) => state.when(
        uninitialized: () => const SizedBox(),
        loaded: (tracks) => ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) => TrackEntryWidget(
            tracks[index],
            () => playerBloc.command.add(PlayerEvent.playList(tracks, index)),
          ),
        ),
      ),
    );
  }
}
