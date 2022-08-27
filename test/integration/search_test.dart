import 'package:audioplayers/audioplayers.dart';
import 'package:cenoyam/app.dart';
import 'package:cenoyam/data/json_mapper.dart';
import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:cenoyam/data/yandex_music_repository.dart';
import 'package:cenoyam/domain/music_repository.dart';
import 'package:cenoyam/domain/yandex_player.dart';
import 'package:cenoyam/presentation/widget/album_widget.dart';
import 'package:cenoyam/presentation/widget/playlist_widget.dart';
import 'package:cenoyam/presentation/widget/track_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data/test_data.dart';

@GenerateNiceMocks([MockSpec<AudioPlayer>()])
import 'search_test.mocks.dart';

void main() {
  final data = TestData();
  final player = MockAudioPlayer();
  final repository =
      YandexMusicRepository(YandexMusicDatasource(data.dio), JsonMapper());
  final getIt = GetIt.asNewInstance()
    ..registerSingleton<MusicRepository>(
      repository,
    )
    ..registerSingleton(YandexPlayer(player, repository));
  when(player.onDurationChanged).thenAnswer((_) => const Stream.empty());
  when(player.onPositionChanged).thenAnswer((_) => const Stream.empty());
  when(player.getDuration()).thenAnswer((_) => Future.value(Duration.zero));

  testWidgets('Navigates to track', (tester) async {
    await tester.pumpWidget(Cenoyam(getIt));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'query');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    final track = find.text(data.trackEntity.title);
    expect(track, findsOneWidget);
    await tester.tap(track);
    await tester.pumpAndSettle();

    expect(find.byType(TrackWidget), findsOneWidget);
    expect(find.text(data.trackEntity.title), findsWidgets);
    expect(
      find.text('Artist: ${data.trackEntity.artistString}'),
      findsOneWidget,
    );
  });
  testWidgets('Navigates to album', (tester) async {
    await tester.pumpWidget(Cenoyam(getIt));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'query');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    final album = find.text(data.albumEntity.title);
    expect(album, findsOneWidget);
    await tester.tap(album);
    await tester.pumpAndSettle();

    expect(find.byType(AlbumWidget), findsOneWidget);
    expect(find.text(data.albumEntity.title), findsWidgets);
    expect(find.textContaining(data.trackEntity.title), findsWidgets);
    expect(
      find.textContaining(data.trackWithMultipleArtistsEntity.title),
      findsOneWidget,
    );
  });
  testWidgets('Navigates to playlist', (tester) async {
    await tester.pumpWidget(Cenoyam(getIt));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'query');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    final playlist = find.text(data.playlistEntity.title);
    expect(playlist, findsOneWidget);
    await tester.tap(playlist);
    await tester.pumpAndSettle();

    expect(find.byType(PlaylistWidget), findsOneWidget);
    expect(find.text(data.playlistEntity.title), findsWidgets);
    expect(find.textContaining(data.trackEntity.title), findsWidgets);
    expect(
      find.textContaining(data.trackWithMultipleArtistsEntity.title),
      findsOneWidget,
    );
  });
}
