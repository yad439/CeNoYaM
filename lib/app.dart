import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'domain/music_repository.dart';
import 'domain/playing_queue.dart';
import 'domain/yandex_player.dart';
import 'presentation/bloc/album_bloc.dart';
import 'presentation/bloc/artist_bloc.dart';
import 'presentation/bloc/login_bloc.dart';
import 'presentation/bloc/player_bloc.dart';
import 'presentation/bloc/playlist_bloc.dart';
import 'presentation/bloc/profile_bloc.dart';
import 'presentation/bloc/search_results_bloc.dart';
import 'presentation/bloc/track_bloc.dart';
import 'presentation/widget/album_widget.dart';
import 'presentation/widget/artist_widget.dart';
import 'presentation/widget/login_screen.dart';
import 'presentation/widget/player_screen.dart';
import 'presentation/widget/playlist_widget.dart';
import 'presentation/widget/search_screen.dart';
import 'presentation/widget/track_widget.dart';

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
            create: (_) => PlayerBloc(
              _getIt.get<YandexPlayer>(),
              _getIt.get<PlayingQueue>(),
            ),
            dispose: (_, value) => value.dispose(),
          ),
          BlocProvider(
            create: (_) => TrackBloc(_getIt.get<MusicRepository>()),
          ),
          BlocProvider(
            create: (_) => AlbumBloc(_getIt.get<MusicRepository>()),
          ),
          BlocProvider(
            create: (_) => PlaylistBloc(_getIt.get<MusicRepository>()),
          ),
          BlocProvider(
            create: (_) => ArtistBloc(_getIt.get<MusicRepository>()),
          ),
          BlocProvider(create: (_) => LoginBloc(_getIt.get<MusicRepository>())),
          BlocProvider(
            create: (_) => ProfileBloc(_getIt.get<MusicRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'CeNoYaM',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            brightness: Brightness.dark,
          ),
          initialRoute: SearchScreen.routeName,
          routes: {
            SearchScreen.routeName: (context) => const SearchScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            TrackWidget.routeName: (context) => PlayerScreen(
                  title: ModalRoute.of(context)!.settings.arguments! as String,
                  child: const TrackWidget(),
                ),
            ArtistWidget.routeName: (context) => PlayerScreen(
                  title: ModalRoute.of(context)!.settings.arguments! as String,
                  child: const ArtistWidget(),
                ),
            AlbumWidget.routeName: (context) => PlayerScreen(
                  title: ModalRoute.of(context)!.settings.arguments! as String,
                  child: const AlbumWidget(),
                ),
            PlaylistWidget.routeName: (context) => PlayerScreen(
                  title: ModalRoute.of(context)!.settings.arguments! as String,
                  child: const PlaylistWidget(),
                ),
          },
        ),
      );
}
