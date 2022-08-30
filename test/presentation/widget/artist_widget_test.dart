import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/presentation/bloc/album_bloc.dart';
import 'package:cenoyam/presentation/bloc/artist_bloc.dart';
import 'package:cenoyam/presentation/widget/artist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

import '../../test_data.dart';

void main() {
  final albumBloc = MockAlbumBloc();
  final artistBloc = MockArtistBloc();
  final data = TestData();

  setUpAll(() {
    whenListen(
      artistBloc,
      Stream.fromIterable([
        ArtistState.loaded(data.artistEntity),
      ]),
      initialState: const ArtistState.uninitialized(),
    );
  });

  testWidgets('Renders albums', (tester) async {
    await tester.pumpWidget(
      Provider<AlbumBloc>.value(
        value: albumBloc,
        child: Provider<ArtistBloc>.value(
          value: artistBloc,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Material(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Column(children: const [ArtistWidget()]),
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
    when(() => mockNavigator.push(any()))
        .thenAnswer((_) => Future<void>.value());

    await tester.pumpWidget(
      Provider<AlbumBloc>.value(
        value: albumBloc,
        child: Provider<ArtistBloc>.value(
          value: artistBloc,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Material(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: MockNavigatorProvider(
                  navigator: mockNavigator,
                  child: Column(children: const [ArtistWidget()]),
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
    verify(() => mockNavigator.push(any(that: isA<MaterialPageRoute<void>>())));
  });
}

class MockAlbumBloc extends MockBloc<int, AlbumState> implements AlbumBloc {}

class MockArtistBloc extends MockBloc<int, ArtistState> implements ArtistBloc {}
