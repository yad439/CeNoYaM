import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/presentation/bloc/album_bloc.dart';
import 'package:cenoyam/presentation/bloc/player_bloc.dart';
import 'package:cenoyam/presentation/bloc/player_event.dart';
import 'package:cenoyam/presentation/widget/album_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../test_data.dart';
@GenerateNiceMocks([MockSpec<PlayerBloc>(), MockSpec<Sink<PlayerEvent>>()])
import 'album_widget_test.mocks.dart';

void main() {
  final playerBloc = MockPlayerBloc();
  final albumBloc = MockAlbumBloc();
  final data = TestData();

  testWidgets('Renders tracks', (tester) async {
    whenListen(
      albumBloc,
      Stream.fromIterable([
        AlbumState.loaded([
          data.trackEntity,
          data.trackWithMultipleArtistsEntity,
          data.unavailableTrackEntity
        ])
      ]),
      initialState: const AlbumState.uninitialized(),
    );

    await tester.pumpWidget(
      Provider<AlbumBloc>.value(
        value: albumBloc,
        child: Provider<PlayerBloc>.value(
          value: playerBloc,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(children: const [AlbumWidget()]),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining(data.trackEntity.title), findsWidgets);
    expect(
      find.textContaining(data.trackWithMultipleArtistsEntity.title),
      findsOneWidget,
    );
    expect(
      find.textContaining(data.unavailableTrackEntity.title),
      findsOneWidget,
    );
  });

  testWidgets('Sets correct play callback', (tester) async {
    whenListen(
      albumBloc,
      Stream.fromIterable([
        AlbumState.loaded([
          data.trackEntity,
        ])
      ]),
      initialState: const AlbumState.uninitialized(),
    );
    final mockSink = MockSink();
    when(playerBloc.command).thenReturn(mockSink);

    await tester.pumpWidget(
      Provider<AlbumBloc>.value(
        value: albumBloc,
        child: Provider<PlayerBloc>.value(
          value: playerBloc,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(children: const [AlbumWidget()]),
          ),
        ),
      ),
    );
    await tester.pump();

    final track = find.text('|>');
    expect(track, findsOneWidget);
    await tester.tap(track);
    expect(
      verify(mockSink.add(captureAny)).captured.single as PlayerEvent,
      // ignore: avoid_types_on_closure_parameters
      (PlayerEvent e) => e.maybeWhen(
        orElse: () => false,
        play: (track) => track == data.trackEntity,
      ),
    );
  });
}

class MockAlbumBloc extends MockBloc<int, AlbumState> implements AlbumBloc {}
