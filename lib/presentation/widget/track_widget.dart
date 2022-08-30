import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/track_bloc.dart';

class TrackWidget extends StatelessWidget {
  const TrackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();
    return Expanded(
      child: Center(
        child: BlocBuilder<TrackBloc, TrackState>(
          builder: (context, state) => state.when(
            uninitialized: () => const SizedBox(),
            loaded: (track) => Column(
              children: [
                Text(
                  track.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Artist: ${track.artistString}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton(
                  child: const Text('Play'),
                  onPressed: () =>
                      playerBloc.command.add(PlayerEvent.play(track)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
