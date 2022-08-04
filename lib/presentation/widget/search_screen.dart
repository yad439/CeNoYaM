import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_results_bloc.dart';
import '../bloc/search_state.dart';
import '../util/list_entry_adapter.dart';
import 'player_screen.dart';

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
                found: (results) => CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Text(
                        'Playlists',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    _buildList(
                      context,
                      results.playlists,
                      const PlaylistEntryAdapter(),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

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
                    BlocProvider.of<BlocT>(context, listen: false).add(
                      adapter.onTapAction(items[index]),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => PlayerScreen(
                          title: adapter.title(item),
                          child: adapter.screen(context, item),
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: items.length,
            ),
          );
}
