import 'package:audioplayers/audioplayers.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'app.dart';
import 'data/json_mapper.dart';
import 'main.config.dart';

void main() {
  final getIt = GetIt.instance;
  configureDependencies(getIt);
  runApp(Cenoyam(getIt));
}

@InjectableInit()
void configureDependencies(GetIt getIt) => $initGetIt(getIt);

@module
abstract class InjectableConfig {
  @Singleton(dispose: disposeAudioPlayer)
  AudioPlayer get audioPlayer => AudioPlayer();
  @Singleton(dispose: disposeDio)
  Dio dio(CookieJar jar) => Dio(BaseOptions(baseUrl: 'https://music.yandex.ru'))
    ..interceptors.add(CookieManager(jar));
  @singleton
  CookieJar get cookieJar => CookieJar();
  @singleton
  JsonMapper get jsonMapper => JsonMapper();
}

void disposeAudioPlayer(AudioPlayer player) => player.dispose();
void disposeDio(Dio dio) => dio.close();
