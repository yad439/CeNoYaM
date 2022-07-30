import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';

import 'domain/music_repository.dart';
import 'domain/yandex_player.dart';
import 'main.config.dart';
import 'presentation/bloc/player_bloc.dart';
import 'presentation/bloc/playlist_bloc.dart';
import 'presentation/bloc/playlist_event.dart';
import 'presentation/widget/player_widget.dart';
import 'presentation/widget/playlist_widget.dart';

void main() {
  final getIt = GetIt.instance;
  configureDependencies(getIt);
  runApp(MyApp(getIt));
}

@InjectableInit()
void configureDependencies(GetIt getIt) => $initGetIt(getIt);

@module
abstract class InjectableConfig {
  @singleton
  AudioPlayer get audioPlayer => AudioPlayer();
}

class MyApp extends StatelessWidget {
  const MyApp(this._getIt, {Key? key}) : super(key: key);
  final GetIt _getIt;

  @override
  Widget build(BuildContext context) {
    final player = _getIt.get<AudioPlayer>();
    final bloc = PlaylistBloc(_getIt.get<MusicRepository>())
      ..add(const PlaylistEvent.load('yamusic-bestsongs', 222057));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CeNoYaM'),
        ),
        body: Center(
          child: Provider(
            create: (_) =>
                PlayerBloc(YandexPlayer(player, _getIt.get<MusicRepository>())),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Provider.value(value: bloc, child: const PlaylistWidget()),
                const PlayerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
