import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/artist.dart';
import '../../domain/entity/album.dart';
import '../../domain/entity/track.dart';
import '../bloc/player_event.dart';
import '../bloc/player_bloc.dart';

class PlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).bottomAppBarColor,
      child: Row(
        children: [
          StreamBuilder<bool>(
              stream: bloc.isPlaying,
              initialData: false,
              builder: (cont, playing) => playing.data!
                  ? TextButton(
                      child: const Text("||"),
                      onPressed: () => bloc.command.add(PlayerEvent.pause()))
                  : TextButton(
                      child: const Text("|>"),
                      onPressed: () => bloc.command.add(PlayerEvent.play(Track(
                          5493020,
                          "test",
                          AlbumMin(0, "qwer"),
                          [ArtistMin(0, "asdf")]))),
                    )),
          Expanded(
            child: Column(
              children: [
                StreamBuilder<Track?>(
                  stream: bloc.currentTrack,
                  initialData: null,
                  builder: (cont, snap) {
                    final track = snap.data;
                    if ((track == null)) {
                      return Text('-');
                    } else {
                      var artist = track.artistString;
                      return Text('$artist - ${track.title}');
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                  child: StreamBuilder<double>(
                    stream: bloc.progress,
                    initialData: 0.0,
                    builder: (cont, progress) => LinearProgressIndicator(
                      value: progress.data!,
                    ),
                  ),
                ),
                Row(
                  children: [
                    StreamBuilder<Duration>(
                      stream: bloc.position,
                      initialData: const Duration(),
                      builder: (cont, snap) => Text(snap.data!.toString()),
                    ),
                    Text('/'),
                    StreamBuilder<Duration>(
                      stream: bloc.duration,
                      initialData: const Duration(),
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
