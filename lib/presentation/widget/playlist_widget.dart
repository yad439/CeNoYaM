import 'package:cenoyam/presentation/bloc/playlist_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/playlist_bloc.dart';
import 'track_widget.dart';

class PlaylistWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) => state.when(
            uninitialized: () => const SizedBox(),
            loaded: (tracks) => ListView(
                  children: tracks
                      .map((track) => TrackWidget(track, () {}))
                      .toList(growable: false),
                )));
  }
}