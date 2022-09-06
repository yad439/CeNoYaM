import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/presentation/bloc/player_bloc.dart';
import 'package:cenoyam/presentation/bloc/player_event.dart';
import 'package:cenoyam/presentation/bloc/playlist_bloc.dart';
import 'package:cenoyam/presentation/bloc/playlist_event.dart';
import 'package:cenoyam/presentation/widget/playlist_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../test_data.dart';
@GenerateNiceMocks([MockSpec<PlayerBloc>(), MockSpec<Sink<PlayerEvent>>()])
import 'playlist_widget_test.mocks.dart';

void main() {
  final playerBloc = MockPlayerBloc();
  final playlistBloc = MockPlaylistBloc();
  final data = TestData();

  testWidgets('Renders tracks', (tester) async {
    whenListen(
      playlistBloc,
      Stream.fromIterable([
        PlaylistState.loaded([
          data.trackEntity,
          data.trackWithMultipleArtistsEntity,
          data.unavailableTrackEntity
        ])
      ]),
      initialState: const PlaylistState.uninitialized(),
    );

    await tester.pumpWidget(
      Provider<PlaylistBloc>.value(
        value: playlistBloc,
        child: Provider<PlayerBloc>.value(
          value: playerBloc,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PlaylistWidget(),
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
      playlistBloc,
      Stream.fromIterable([
        PlaylistState.loaded([
          data.trackEntity,
        ])
      ]),
      initialState: const PlaylistState.uninitialized(),
    );
    final mockSink = MockSink();
    when(playerBloc.command).thenReturn(mockSink);

    await tester.pumpWidget(
      Provider<PlaylistBloc>.value(
        value: playlistBloc,
        child: Provider<PlayerBloc>.value(
          value: playerBloc,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PlaylistWidget(),
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
        playList: (tracks, index) => tracks.length == 1 && index == 0,
      ),
    );
  });
}

class MockPlaylistBloc extends MockBloc<PlaylistEvent, PlaylistState>
    implements PlaylistBloc {}
