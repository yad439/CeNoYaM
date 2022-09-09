// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/domain/enum/artist_subcategory.dart';
import 'package:cenoyam/presentation/bloc/album_bloc.dart';
import 'package:cenoyam/presentation/bloc/artist_bloc.dart';
import 'package:cenoyam/presentation/bloc/artist_event.dart';
import 'package:cenoyam/presentation/bloc/artist_state.dart';
import 'package:cenoyam/presentation/bloc/player_bloc.dart';
import 'package:cenoyam/presentation/bloc/player_event.dart';
import 'package:cenoyam/presentation/widget/artist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

import '../../test_data.dart';

void main() {
  final artistBloc = MockArtistBloc();
  late final TestData data;

  setUpAll(() {
    data = TestData();
    whenListen(
      artistBloc,
      Stream.fromIterable([
        ArtistState.loading(data.artistAlbumsEntity.id),
        ArtistState.loaded(data.artistAlbumsEntity),
      ]),
      initialState: const ArtistState.initial(),
    );
    registerFallbackValue(const ArtistEvent.load(0, null));
  });

  testWidgets('Renders albums', (tester) async {
    await tester.pumpWidget(
      Provider<AlbumBloc>(
        create: (_) => MockAlbumBloc(),
        child: Provider<ArtistBloc>.value(
          value: artistBloc,
          child: Localizations(
            locale: const Locale('en'),
            delegates: const [
              DefaultWidgetsLocalizations.delegate,
              DefaultMaterialLocalizations.delegate
            ],
            child: const MediaQuery(
              data: MediaQueryData(),
              child: Material(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: ArtistWidget(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(data.albumEntity.title), findsOneWidget);
    expect(find.text('album title 2'), findsOneWidget);
  });

  testWidgets('Navigates to album', (tester) async {
    final mockNavigator = MockNavigator();
    when(
      () => mockNavigator.pushNamed(any(), arguments: any(named: 'arguments')),
    ).thenAnswer((_) => Future<void>.value());
    final albumBloc = MockAlbumBloc();
    await tester.pumpWidget(
      Provider<AlbumBloc>.value(
        value: albumBloc,
        child: Provider<ArtistBloc>.value(
          value: artistBloc,
          child: Localizations(
            locale: const Locale('en'),
            delegates: const [
              DefaultWidgetsLocalizations.delegate,
              DefaultMaterialLocalizations.delegate
            ],
            child: MediaQuery(
              data: const MediaQueryData(),
              child: Material(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: MockNavigatorProvider(
                    navigator: mockNavigator,
                    child: const ArtistWidget(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final album = find.text(data.albumEntity.title);
    expect(album, findsOneWidget);
    await tester.tap(album);

    verify(() => albumBloc.add(data.albumEntity.id));
    verify(
      () =>
          mockNavigator.pushNamed('/album', arguments: data.albumEntity.title),
    );
  });

  testWidgets('Renders tracks', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AlbumBloc>(
            create: (_) => MockAlbumBloc(),
          ),
          Provider<ArtistBloc>.value(
            value: artistBloc,
          ),
          Provider<PlayerBloc>(
            create: (_) => MockPlayerBloc(),
          ),
        ],
        child: Localizations(
          locale: const Locale('en'),
          delegates: const [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate
          ],
          child: const MediaQuery(
            data: MediaQueryData(),
            child: Material(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ArtistWidget(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Tracks'));
    await tester.pumpAndSettle();

    expect(find.textContaining(data.trackEntity.title), findsOneWidget);
    final lastEvent =
        verify(() => artistBloc.add(captureAny())).captured.last as ArtistEvent;
    expect(
      lastEvent,
      (ArtistEvent event) => event.maybeWhen(
        fetchAdditinal: (subcategory) =>
            subcategory == ArtistSubcategory.tracks,
        orElse: () => false,
      ),
    );
  });

  testWidgets('Plays track', (tester) async {
    final playerBloc = MockPlayerBloc();
    final command = StreamController<PlayerEvent>();
    addTearDown(command.close);
    when(() => playerBloc.command).thenAnswer((_) => command.sink);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AlbumBloc>(
            create: (_) => MockAlbumBloc(),
          ),
          Provider<ArtistBloc>.value(
            value: artistBloc,
          ),
          Provider<PlayerBloc>.value(
            value: playerBloc,
          ),
        ],
        child: Localizations(
          locale: const Locale('en'),
          delegates: const [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate
          ],
          child: const MediaQuery(
            data: MediaQueryData(),
            child: Material(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ArtistWidget(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Tracks'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, '|>').first);
    expect(
      command.stream,
      emits(
        (PlayerEvent event) =>
            event.maybeMap(playList: (_) => true, orElse: () => false),
      ),
    );
  });
}

class MockAlbumBloc extends MockBloc<int, AlbumState> implements AlbumBloc {}

class MockArtistBloc extends MockBloc<ArtistEvent, ArtistState>
    implements ArtistBloc {}

class MockPlayerBloc extends Mock implements PlayerBloc {}
