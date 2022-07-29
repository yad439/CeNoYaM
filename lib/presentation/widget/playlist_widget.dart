import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/playlist_bloc.dart';
import '../bloc/playlist_state.dart';
import 'track_widget.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) => state.when(
        uninitialized: () => const SizedBox(),
        loaded: (tracks) => Expanded(
          child: ListView(
            children: tracks
                .map(
                  (track) => TrackWidget(track, () {
                    playerBloc.command.add(PlayerEvent.play(track));
                  }),
                )
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}
