import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/album.dart';
import '../../domain/entity/track.dart';
import '../../domain/enum/artist_subcategory.dart';
import '../bloc/album_bloc.dart';
import '../bloc/artist_bloc.dart';
import '../bloc/artist_event.dart';
import '../bloc/artist_state.dart';
import '../bloc/loading_state.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import 'album_widget.dart';
import 'player_screen.dart';
import 'track_entry_widget.dart';

class ArtistWidget extends StatefulWidget {
  const ArtistWidget({super.key});
  @override
  State<ArtistWidget> createState() => _ArtistWidgetState();
}

class _ArtistWidgetState extends State<ArtistWidget>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.index == 0) {
      context
          .read<ArtistBloc>()
          .add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.albums));
    } else {
      context
          .read<ArtistBloc>()
          .add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.tracks));
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TabBar(
            tabs: const [Tab(text: 'Albums'), Tab(text: 'Tracks')],
            controller: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [_AlbumsTab(), _TracksTab()],
            ),
          ),
        ],
      );
}

class _AlbumsTab extends StatelessWidget {
  const _AlbumsTab();

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

class _TracksTab extends StatelessWidget {
  const _TracksTab();

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();
    return BlocSelector<ArtistBloc, ArtistState, LoadingState<List<TrackMin>>>(
      selector: (state) => state.when(
        initial: () => const LoadingState.uninitialized(),
        loading: (id) => const LoadingState.uninitialized(),
        loaded: (artist) => LoadingState.loaded(artist.popularTracks),
      ),
      builder: (context, state) => state.when(
        uninitialized: () => const SizedBox(),
        loaded: (tracks) => ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) => TrackEntryWidget(
            tracks[index],
            () => playerBloc.command.add(PlayerEvent.play(tracks[index])),
          ),
        ),
      ),
    );
  }
}
