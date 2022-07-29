import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/album.dart';
import '../../domain/entity/artist.dart';
import '../../domain/entity/track.dart';
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
          StreamBuilder<bool>(
            stream: bloc.isPlaying,
            initialData: false,
            builder: (cont, playing) => playing.data!
                ? TextButton(
                    child: const Text('||'),
                    onPressed: () =>
                        bloc.command.add(const PlayerEvent.pause()),
                  )
                : TextButton(
                    child: const Text('|>'),
                    onPressed: () => bloc.command.add(
                      PlayerEvent.play(
                        Track(
                          5493020,
                          'test',
                          AlbumMin(0, 'qwer'),
                          [ArtistMin(0, 'asdf')],
                        ),
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: Column(
              children: [
                StreamBuilder<Track?>(
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
}
