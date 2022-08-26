import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/domain/entity/track.dart';
import 'package:cenoyam/presentation/bloc/loading_state.dart';
import 'package:cenoyam/presentation/bloc/player_bloc.dart';
import 'package:cenoyam/presentation/bloc/player_event.dart';
import 'package:cenoyam/presentation/bloc/track_bloc.dart';
import 'package:cenoyam/presentation/widget/track_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../data/test_data.dart';
@GenerateNiceMocks([MockSpec<PlayerBloc>(), MockSpec<Sink<PlayerEvent>>()])
import 'track_widget_test.mocks.dart';

void main() {
  final playerBloc = MockPlayerBloc();
  final trackBloc = MockTrackBloc();
  final data = TestData();

  whenListen(
    trackBloc,
    Stream.fromIterable([LoadingState.loaded(data.trackEntity)]),
    initialState: const LoadingState<Track>.uninitialized(),
  );

  testWidgets('Renders track', (tester) async {
    await tester.pumpWidget(
      Provider<TrackBloc>.value(
        value: trackBloc,
        child: Provider<PlayerBloc>.value(
          value: playerBloc,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(children: const [TrackWidget()]),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining(data.trackEntity.title), findsOneWidget);
    expect(find.textContaining(data.trackEntity.artistString), findsOneWidget);
  });

  testWidgets('Sets correct play callback', (tester) async {
    final mockSink = MockSink();
    when(playerBloc.command).thenReturn(mockSink);

    await tester.pumpWidget(
      Provider<TrackBloc>.value(
        value: trackBloc,
        child: Provider<PlayerBloc>.value(
          value: playerBloc,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(children: const [TrackWidget()]),
          ),
        ),
      ),
    );
    await tester.pump();

    final track = find.text('Play');
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

class MockTrackBloc extends MockBloc<int, LoadingState<Track>>
    implements TrackBloc {}
