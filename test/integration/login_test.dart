import 'package:cenoyam/app.dart';
import 'package:cenoyam/data/json_mapper.dart';
import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:cenoyam/data/yandex_music_repository.dart';
import 'package:cenoyam/domain/music_repository.dart';
import 'package:cenoyam/presentation/widget/search_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';

void main() {
  final data = TestData();
  final getIt = GetIt.asNewInstance()
    ..registerSingleton<MusicRepository>(
      YandexMusicRepository(YandexMusicDatasource(data.dio), JsonMapper()),
    );

  when(data.dio.get<Map<String, dynamic>>('/api/v2.1/handlers/auth'))
      .thenAnswer(
    (_) async => Response(
      data: {'logged': false},
      requestOptions: RequestOptions(path: ''),
    ),
  );

  testWidgets('Performs successful login', (widgetTester) async {
    await widgetTester.pumpWidget(Cenoyam(getIt));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text('Login'));
    await widgetTester.pumpAndSettle();

    final loginField = find.widgetWithText(TextFormField, 'Login');
    expect(loginField, findsOneWidget);
    await widgetTester.enterText(loginField, 'correct_login');
    final passwordField = find.widgetWithText(TextFormField, 'Password');
    expect(passwordField, findsOneWidget);
    await widgetTester.enterText(passwordField, 'correct_password');

    when(data.dio.get<Map<String, dynamic>>('/api/v2.1/handlers/auth'))
        .thenAnswer(
      (_) async => Response(
        data: data.profileInfoJson,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    await widgetTester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await widgetTester.pumpAndSettle();

    expect(find.byType(SearchScreen).hitTestable(), findsOneWidget);
    expect(find.text('some_login'), findsOneWidget);
  });
}
