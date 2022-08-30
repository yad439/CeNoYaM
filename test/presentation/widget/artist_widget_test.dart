import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/domain/entity/album.dart';
import 'package:cenoyam/domain/entity/track.dart';
import 'package:cenoyam/presentation/bloc/album_bloc.dart';
import 'package:cenoyam/presentation/bloc/artist_bloc.dart';
import 'package:cenoyam/presentation/bloc/loading_state.dart';
import 'package:cenoyam/presentation/widget/artist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

import '../../data/test_data.dart';

void main() {
  final albumBloc = MockAlbumBloc();
  final artistBloc = MockArtistBloc();
  final data = TestData();

  setUpAll(() {
    whenListen(
      artistBloc,
      Stream.fromIterable([
        LoadingState.loaded([
          data.albumEntity,
        ])
      ]),
      initialState: const LoadingState<List<AlbumMin>>.uninitialized(),
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

    expect(find.textContaining(data.albumEntity.title), findsOneWidget);
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

class MockAlbumBloc extends MockBloc<int, LoadingState<List<TrackMin>>>
    implements AlbumBloc {}

class MockArtistBloc extends MockBloc<int, LoadingState<List<AlbumMin>>>
    implements ArtistBloc {}
