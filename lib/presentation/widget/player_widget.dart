import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/track.dart';
import '../../domain/enum/player_state.dart';
import '../bloc/duration_state.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

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
                      return Text('${track.artistString} - ${track.title}');
                    }
                  },
                ),
                StreamBuilder<DurationState>(
                  stream: bloc.durationState,
                  initialData:
                      const DurationState(Duration.zero, Duration.zero),
                  builder: (cont, snap) => ProgressBar(
                    progress: snap.data!.position,
                    total: snap.data!.duration,
                    onSeek: (pos) => bloc.command.add(PlayerEvent.seek(pos)),
                  ),
                ),
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
