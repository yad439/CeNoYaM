import 'package:audioplayers/audioplayers.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'main.config.dart';

void main() async {
  final getIt = GetIt.instance;
  configureDependencies(getIt);
  await getIt.allReady();
  runApp(Cenoyam(getIt));
}

@InjectableInit()
void configureDependencies(GetIt getIt) => $initGetIt(getIt);

@module
abstract class InjectableConfig {
  @Singleton(dispose: disposeAudioPlayer)
  AudioPlayer get audioPlayer => AudioPlayer();
  @Singleton(dispose: disposeDio)
  Dio dio(CookieJar jar) => Dio(
        BaseOptions(
          baseUrl: 'https://music.yandex.ru',
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'X-Retpath-Y': 'https%3A%2F%2Fmusic.yandex.ru%2F'
          },
        ),
      )..interceptors.add(CookieManager(jar));
  @singleton
  Future<CookieJar> get cookieJar async {
    if (kIsWeb) {
      return CookieJar();
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      return PersistCookieJar(storage: FileStorage(appDocDir.path));
    }
  }
}

void disposeAudioPlayer(AudioPlayer player) => player.dispose();
void disposeDio(Dio dio) => dio.close();
