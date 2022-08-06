import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'domain/music_repository.dart';
import 'domain/yandex_player.dart';
import 'presentation/bloc/login_bloc.dart';
import 'presentation/bloc/player_bloc.dart';
import 'presentation/bloc/playlist_bloc.dart';
import 'presentation/bloc/search_results_bloc.dart';
import 'presentation/bloc/track_bloc.dart';
import 'presentation/widget/search_screen.dart';

class Cenoyam extends StatelessWidget {
  const Cenoyam(this._getIt, {super.key});
  final GetIt _getIt;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          BlocProvider(
            create: (_) => SearchResultsBloc(_getIt.get<MusicRepository>()),
          ),
          Provider<PlayerBloc>(
            create: (_) => PlayerBloc(_getIt.get<YandexPlayer>()),
            dispose: (_, value) => value.dispose(),
          ),
          BlocProvider(
            create: (_) => TrackBloc(_getIt.get<MusicRepository>()),
          ),
          BlocProvider(
            create: (_) => PlaylistBloc(_getIt.get<MusicRepository>()),
          ),
          BlocProvider(create: (_) => LoginBloc(_getIt.get<MusicRepository>())),
        ],
        child: MaterialApp(
          title: 'CeNoYaM',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            brightness: Brightness.dark,
          ),
          home: const SearchScreen(),
        ),
      );
}
