import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/album.dart';
import '../../domain/entity/artist.dart';
import '../../domain/entity/track.dart';
import '../../domain/player_state.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).bottomAppBarColor,
      child: Row(
        children: [
          StreamBuilder<PlayerState>(
            stream: bloc.state,
            initialData: PlayerState.stopped,
            builder: (cont, state) => _buildButton(bloc, state.data!),
          ),
          Expanded(
            child: Column(
              children: [
                StreamBuilder<TrackMin?>(
                  stream: bloc.currentTrack,
                  builder: (cont, snap) {
                    final track = snap.data;
                    if (track == null) {
                      return const Text('-');
                    } else {
                      final artist = track.artistString;
                      return Text('$artist - ${track.title}');
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                  child: StreamBuilder<double>(
                    stream: bloc.progress,
                    initialData: 0,
                    builder: (cont, progress) => LinearProgressIndicator(
                      value: progress.data,
                    ),
                  ),
                ),
                Row(
                  children: [
                    StreamBuilder<Duration>(
                      stream: bloc.position,
                      initialData: Duration.zero,
                      builder: (cont, snap) => Text(snap.data!.toString()),
                    ),
                    const Text('/'),
                    StreamBuilder<Duration>(
                      stream: bloc.duration,
                      initialData: Duration.zero,
                      builder: (cont, snap) => Text(snap.data!.toString()),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(PlayerBloc bloc, PlayerState state) {
    switch (state) {
      case PlayerState.playing:
        return TextButton(
          child: const Text('||'),
          onPressed: () => bloc.command.add(const PlayerEvent.pause()),
        );
      case PlayerState.paused:
        return TextButton(
          child: const Text('|>'),
          onPressed: () => bloc.command.add(const PlayerEvent.resume()),
        );
      case PlayerState.stopped:
        return const TextButton(onPressed: null, child: Text('|>'));
    }
  }
}
