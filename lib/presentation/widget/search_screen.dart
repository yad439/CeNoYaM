import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/album.dart';
import '../../domain/entity/artist.dart';
import '../../domain/entity/playlist.dart';
import '../../domain/entity/track.dart';
import '../bloc/album_bloc.dart';
import '../bloc/artist_bloc.dart';
import '../bloc/artist_event.dart';
import '../bloc/artist_state.dart';
import '../bloc/playlist_bloc.dart';
import '../bloc/playlist_event.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../bloc/search_results_bloc.dart';
import '../bloc/track_bloc.dart';
import '../util/list_entry_adapter.dart';
import 'login_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SearchResultsBloc>(context);
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.state.whenOrNull(
      unknown: () => profileBloc.add(ProfileEvent.update),
    );
    final queryController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) => state.when(
              unknown: () => const SizedBox.shrink(),
              anonimous: () => TextButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, LoginScreen.routeName);
                  profileBloc.add(ProfileEvent.update);
                },
                child: const Text('Login'),
              ),
              loggedIn: (username) => Center(
                child: Text(username),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: queryController),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Text('Search'),
                  onPressed: () {
                    bloc.add(queryController.text);
                  },
                ),
              ],
            ),
          ),
          const _ResultList()
        ],
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList();

  @override
  Widget build(BuildContext context) => Expanded(
        child: BlocBuilder<SearchResultsBloc, SearchState>(
          builder: (context, state) => state.when(
            uninitialized: () => const SizedBox.shrink(),
            loaded: (results) => CustomScrollView(
              slivers: [
                if (results.artists.isNotEmpty)
                  ..._buildEntry<ArtistMin, ArtistEvent, ArtistState,
                      ArtistBloc>(
                    context,
                    'Artists',
                    results.artists,
                    const ArtistEntryAdapter(),
                  ),
                if (results.tracks.isNotEmpty)
                  ..._buildEntry<TrackMin, int, TrackState, TrackBloc>(
                    context,
                    'Tracks',
                    results.tracks,
                    const TrackEntryAdapter(),
                  ),
                if (results.albums.isNotEmpty)
                  ..._buildEntry<AlbumMin, int, AlbumState, AlbumBloc>(
                    context,
                    'Albums',
                    results.albums,
                    const AlbumEntryAdapter(),
                  ),
                if (results.playlists.isNotEmpty)
                  ..._buildEntry<PlaylistMin, PlaylistEvent, PlaylistState,
                      PlaylistBloc>(
                    context,
                    'Playlists',
                    results.playlists,
                    const PlaylistEntryAdapter(),
                  ),
              ],
            ),
          ),
        ),
      );

  static List<Widget>
      _buildEntry<T, EventT, StateT, BlocT extends Bloc<EventT, StateT>>(
    BuildContext context,
    String name,
    List<T> items,
    ListEntryAdapter<T, EventT, StateT, BlocT> adapter,
  ) =>
          [
            SliverToBoxAdapter(
              child: Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            _buildList<T, EventT, StateT, BlocT>(
              context,
              items,
              adapter,
            ),
          ];

  static SliverList
      _buildList<T, EventT, StateT, BlocT extends Bloc<EventT, StateT>>(
    BuildContext context,
    List<T> items,
    ListEntryAdapter<T, EventT, StateT, BlocT> adapter,
  ) =>
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(adapter.title(item)),
                  subtitle: Text(adapter.subtitle(item)),
                  onTap: () {
                    BlocProvider.of<BlocT>(context).add(
                      adapter.onTapAction(items[index]),
                    );
                    Navigator.pushNamed(
                      context,
                      adapter.routeName,
                      arguments: adapter.title(item),
                    );
                  },
                );
              },
              childCount: items.length,
            ),
          );
}
