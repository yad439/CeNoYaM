import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/domain/entity/search_results.dart';
import 'package:cenoyam/presentation/bloc/album_bloc.dart';
import 'package:cenoyam/presentation/bloc/loading_state.dart';
import 'package:cenoyam/presentation/bloc/playlist_bloc.dart';
import 'package:cenoyam/presentation/bloc/playlist_event.dart';
import 'package:cenoyam/presentation/bloc/profile_bloc.dart';
import 'package:cenoyam/presentation/bloc/profile_event.dart';
import 'package:cenoyam/presentation/bloc/profile_state.dart';
import 'package:cenoyam/presentation/bloc/search_results_bloc.dart';
import 'package:cenoyam/presentation/bloc/track_bloc.dart';
import 'package:cenoyam/presentation/widget/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mockito;

import '../../data/test_data.dart';

@GenerateNiceMocks(
  [MockSpec<TrackBloc>(), MockSpec<AlbumBloc>(), MockSpec<PlaylistBloc>()],
)
import 'search_screen_test.mocks.dart';

void main() {
  final searchResultsBloc = MockSearchResultsBloc();
  final profileBloc = MockProfileBloc();
  final navigator = MockNavigator();
  final stateVariants =
      ValueVariant({StateIncomingType.initial, StateIncomingType.stream});

  setUp(() {
    whenListen(
      searchResultsBloc,
      const Stream<LoadingState<SearchResults>>.empty(),
      initialState: const LoadingState<SearchResults>.uninitialized(),
    );
    whenListen(
      profileBloc,
      const Stream<ProfileState>.empty(),
      initialState: const ProfileState.unknown(),
    );
  });
  tearDown(() {
    reset(searchResultsBloc);
    reset(profileBloc);
    reset(navigator);
  });

  testWidgets('If login status is unknown, checks it', (widgetTester) async {
    whenListen(
      profileBloc,
      const Stream<ProfileState>.empty(),
      initialState: const ProfileState.unknown(),
    );
    await widgetTester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
          BlocProvider<ProfileBloc>.value(value: profileBloc),
        ],
        child: const MaterialApp(
          home: SearchScreen(),
        ),
      ),
    );
    await widgetTester.pump();

    verify(() => profileBloc.add(ProfileEvent.update));
  });

  testWidgets('If logged in, appbar shows username', variant: stateVariants,
      (widgetTester) async {
    switch (stateVariants.currentValue) {
      case StateIncomingType.initial:
        whenListen(
          profileBloc,
          const Stream<ProfileState>.empty(),
          initialState: const ProfileState.loggedIn('some_username'),
        );
        break;
      case StateIncomingType.stream:
        whenListen(
          profileBloc,
          Stream.fromIterable([
            const ProfileState.loggedIn('some_username'),
          ]),
          initialState: const ProfileState.unknown(),
        );
        break;
      case null:
    }

    await widgetTester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
          BlocProvider<ProfileBloc>.value(value: profileBloc),
        ],
        child: const MaterialApp(
          home: SearchScreen(),
        ),
      ),
    );
    await widgetTester.pump();

    expect(find.text('some_username'), findsOneWidget);
  });

  group('If not logged in', () {
    testWidgets('shows login button', variant: stateVariants,
        (widgetTester) async {
      switch (stateVariants.currentValue) {
        case StateIncomingType.initial:
          whenListen(
            profileBloc,
            const Stream<ProfileState>.empty(),
            initialState: const ProfileState.anonimous(),
          );
          break;
        case StateIncomingType.stream:
          whenListen(
            profileBloc,
            Stream.fromIterable([
              const ProfileState.anonimous(),
            ]),
            initialState: const ProfileState.unknown(),
          );
          break;
        case null:
      }

      await widgetTester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
            BlocProvider<ProfileBloc>.value(value: profileBloc),
          ],
          child: const MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );
      await widgetTester.pump();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('login button opens login screen', (widgetTester) async {
      whenListen(
        profileBloc,
        const Stream<ProfileState>.empty(),
        initialState: const ProfileState.anonimous(),
      );
      when(() => navigator.push(any())).thenAnswer((_) => Future.value());

      await widgetTester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
            BlocProvider<ProfileBloc>.value(value: profileBloc),
          ],
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: const SearchScreen(),
            ),
          ),
        ),
      );
      await widgetTester.pump();

      await widgetTester.tap(find.text('Login'));
      await widgetTester.pumpAndSettle();

      verify(() => navigator.push(any(that: isA<MaterialPageRoute<void>>())));
    });
  });
  group('Results view', () {
    final data = TestData();
    setUp(() {
      whenListen(
        searchResultsBloc,
        Stream.fromIterable([
          LoadingState<SearchResults>.loaded(data.searchResultsEntity),
        ]),
        initialState: const LoadingState<SearchResults>.uninitialized(),
      );
    });
    group('renderes', () {
      testWidgets('tracks', (widgetTester) async {
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
            ],
            child: const MaterialApp(
              home: SearchScreen(),
            ),
          ),
        );
        await widgetTester.pump();

        expect(find.text(data.trackEntity.title), findsWidgets);
        expect(
          find.text(data.trackWithMultipleArtistsEntity.title),
          findsOneWidget,
        );
      });
      testWidgets('artists', skip: true, (widgetTester) async {
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
            ],
            child: const MaterialApp(
              home: SearchScreen(),
            ),
          ),
        );
        await widgetTester.pump();

        expect(find.text(data.artistEntity.name), findsWidgets);
      });
      testWidgets('albums', (widgetTester) async {
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
            ],
            child: const MaterialApp(
              home: SearchScreen(),
            ),
          ),
        );
        await widgetTester.pump();

        expect(find.text(data.albumEntity.title), findsWidgets);
      });
      testWidgets('playlists', (widgetTester) async {
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
            ],
            child: const MaterialApp(
              home: SearchScreen(),
            ),
          ),
        );
        await widgetTester.pump();

        expect(find.text(data.playlistEntity.title), findsWidgets);
      });
    });

    group('on press, opens', () {
      testWidgets('track', (widgetTester) async {
        final trackBloc = MockTrackBloc();
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
              BlocProvider<TrackBloc>.value(value: trackBloc),
            ],
            child: const MaterialApp(
              home: SearchScreen(),
            ),
          ),
        );
        await widgetTester.pump();

        await widgetTester
            .tap(find.text(data.trackWithMultipleArtistsEntity.title));
        mockito.verify(trackBloc.add(data.trackWithMultipleArtistsEntity.id));
      });
      testWidgets('artist', skip: true, (widgetTester) async {
        // final artistBloc = MockArtistBloc();
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
              // BlocProvider<ArtistBloc>.value(value: artistBloc),
            ],
            child: const MaterialApp(
              home: SearchScreen(),
            ),
          ),
        );
        await widgetTester.pump();

        await widgetTester.tap(find.text(data.artistEntity.name));
        // mockito.verify(artistBloc.add(data.artistEntity.id));
      });
      testWidgets('album', (widgetTester) async {
        final albumBloc = MockAlbumBloc();
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
              BlocProvider<AlbumBloc>.value(value: albumBloc),
            ],
            child: const MaterialApp(
              home: SearchScreen(),
            ),
          ),
        );
        await widgetTester.pump();

        await widgetTester.tap(find.text(data.albumEntity.title));
        mockito.verify(albumBloc.add(data.albumEntity.id));
      });
      testWidgets('playlist', (widgetTester) async {
        final playlistBloc = MockPlaylistBloc();
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
              BlocProvider<PlaylistBloc>.value(value: playlistBloc),
            ],
            child: const MaterialApp(
              home: SearchScreen(),
            ),
          ),
        );
        await widgetTester.pump();

        await widgetTester.tap(find.text(data.playlistEntity.title));
        expect(
          (mockito.verify(playlistBloc.add(mockito.captureAny)).captured.single
                  as PlaylistEvent)
              .id,
          data.playlistEntity.id,
        );
      });
    });
  });
  testWidgets('Search bar sends search request', (widgetTester) async {
    await widgetTester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
          BlocProvider<ProfileBloc>.value(value: profileBloc),
        ],
        child: const MaterialApp(
          home: SearchScreen(),
        ),
      ),
    );
    await widgetTester.enterText(find.byType(TextField), 'some query');
    await widgetTester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    verify(() => searchResultsBloc.add('some query'));
  });
}

enum StateIncomingType { initial, stream }

class MockSearchResultsBloc
    extends MockBloc<String, LoadingState<SearchResults>>
    implements SearchResultsBloc {}

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}
