import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/album_bloc.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import 'track_entry_widget.dart';

class AlbumWidget extends StatelessWidget {
  const AlbumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();
    return BlocBuilder<AlbumBloc, AlbumState>(
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
