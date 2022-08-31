import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/album.dart';
import '../bloc/album_bloc.dart';
import '../bloc/artist_bloc.dart';
import '../bloc/artist_state.dart';
import '../bloc/loading_state.dart';
import 'album_widget.dart';
import 'player_screen.dart';

class ArtistWidget extends StatelessWidget {
  const ArtistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final albumBloc = context.read<AlbumBloc>();
    return BlocSelector<ArtistBloc, ArtistState, LoadingState<List<AlbumMin>>>(
      selector: (state) => state.when(
        initial: () => const LoadingState.uninitialized(),
        loading: (id) => const LoadingState.uninitialized(),
        loaded: (artist) => LoadingState.loaded(artist.albums),
      ),
      builder: (context, state) => state.when(
        uninitialized: () => const SizedBox(),
        loaded: (albums) => ListView.builder(
          itemCount: albums.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(albums[index].title),
            onTap: () {
              albumBloc.add(albums[index].id);
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => PlayerScreen(
                    title: albums[index].title,
                    child: const AlbumWidget(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
