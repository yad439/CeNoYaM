import 'package:audioplayers/audioplayers.dart';
import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:flutter/material.dart';

import 'data/yandex_music_repository.dart';

void main() {
  runApp(MyApp(YandexMusicRepository(YandexMusicDatasource())));
}

class MyApp extends StatelessWidget {
  final YandexMusicRepository _repository;

  MyApp(this._repository);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('CeNoYaM'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Text'),
              TextButton(
                onPressed: () => _repository
                    .getDownloadUrl(5493020)
                    .then((value) => player.play(value.toString())),
                child: Text('Play'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
