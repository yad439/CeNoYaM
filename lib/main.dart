import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/yandex_music_datasource.dart';
import 'data/yandex_music_repository.dart';
import 'domain/yandex_player.dart';
import 'presentation/bloc/player_bloc.dart';
import 'presentation/bloc/playlist_bloc.dart';
import 'presentation/bloc/playlist_event.dart';
import 'presentation/widget/player_widget.dart';
import 'presentation/widget/playlist_widget.dart';

void main() {
  runApp(MyApp(YandexMusicRepository(YandexMusicDatasource())));
}

class MyApp extends StatelessWidget {
  const MyApp(this._repository, {Key? key}) : super(key: key);
  final YandexMusicRepository _repository;

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    final bloc = PlaylistBloc(_repository)
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
            create: (_) => PlayerBloc(YandexPlayer(player, _repository)),
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
