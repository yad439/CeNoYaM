import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/playlist_bloc.dart';
import '../bloc/playlist_event.dart';
import '../bloc/search_results_bloc.dart';
import '../bloc/search_state.dart';
import 'player_screen.dart';
import 'playlist_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SearchResultsBloc>(context, listen: false);
    final queryController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
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
          Expanded(
            child: BlocBuilder<SearchResultsBloc, SearchState>(
              builder: (context, state) => state.when(
                initial: () => const SizedBox.shrink(),
                found: (results) => ListView.builder(
                  itemCount: results.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = results.playlists[index];
                    return ListTile(
                      title: Text(playlist.title),
                      subtitle: Text(playlist.owner.login),
                      onTap: () {
                        BlocProvider.of<PlaylistBloc>(context).add(
                          PlaylistEvent.load(
                            playlist.owner.login,
                            playlist.id,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => PlayerScreen(
                              title: playlist.title,
                              child: const PlaylistWidget(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
