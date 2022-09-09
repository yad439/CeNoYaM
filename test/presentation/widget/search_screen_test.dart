import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/domain/entity/search_results.dart';
import 'package:cenoyam/domain/enum/artist_subcategory.dart';
import 'package:cenoyam/presentation/bloc/album_bloc.dart';
import 'package:cenoyam/presentation/bloc/artist_bloc.dart';
import 'package:cenoyam/presentation/bloc/artist_event.dart';
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

import '../../test_data.dart';
@GenerateNiceMocks(
  [
    MockSpec<TrackBloc>(),
    MockSpec<AlbumBloc>(),
    MockSpec<PlaylistBloc>(),
    MockSpec<ArtistBloc>()
  ],
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
      const Stream<SearchState>.empty(),
      initialState: const SearchState.uninitialized(),
    );
    whenListen(
      profileBloc,
      const Stream<ProfileState>.empty(),
      initialState: const ProfileState.unknown(),
    );
    when(
      () => navigator.pushNamed(any(), arguments: any(named: 'arguments')),
    ).thenAnswer((_) => Future.value());
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

      verify(() => navigator.pushNamed('/login'));
    });
  });
  group('Results view', () {
    final data = TestData();
    setUp(() {
      whenListen(
        searchResultsBloc,
        Stream.fromIterable([
          SearchState.loaded(data.searchResultsEntity),
        ]),
        initialState: const SearchState.uninitialized(),
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
      testWidgets('artists', (widgetTester) async {
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

        final playlist =
            find.text(data.playlistEntity.title, skipOffstage: false);
        expect(playlist, findsOneWidget);
        await widgetTester.dragUntilVisible(
          find.text(data.playlistEntity.title),
          find.byType(CustomScrollView),
          const Offset(0, -100),
        );
        expect(find.text(data.playlistEntity.title), findsOneWidget);
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
            child: MaterialApp(
              home: MockNavigatorProvider(
                navigator: navigator,
                child: const SearchScreen(),
              ),
            ),
          ),
        );
        await widgetTester.pump();

        await widgetTester
            .tap(find.text(data.trackWithMultipleArtistsEntity.title));
        mockito.verify(trackBloc.add(data.trackWithMultipleArtistsEntity.id));
        verify(
          () => navigator.pushNamed(
            '/track',
            arguments: data.trackWithMultipleArtistsEntity.title,
          ),
        );
      });
      testWidgets('artist', (widgetTester) async {
        final artistBloc = MockArtistBloc();
        whenListen(
          searchResultsBloc,
          Stream.fromIterable([
            SearchState.loaded(
              SearchResults(
                const [],
                [data.artistEntity],
                const [],
                const [],
              ),
            ),
          ]),
          initialState: const SearchState.uninitialized(),
        );
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchResultsBloc>.value(value: searchResultsBloc),
              BlocProvider<ProfileBloc>.value(value: profileBloc),
              BlocProvider<ArtistBloc>.value(value: artistBloc),
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

        await widgetTester.tap(find.text(data.artistEntity.name));
        (mockito.verify(artistBloc.add(mockito.captureAny)).captured.single
                as ArtistEvent)
            .when(
          load: (id, subcategory) {
            expect(id, data.artistEntity.id);
            expect(subcategory, ArtistSubcategory.albums);
          },
          fetchAdditinal: (_) {
            expect(false, true);
          },
        );
        verify(
          () => navigator.pushNamed(
            '/artist',
            arguments: data.artistEntity.name,
          ),
        );
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
            child: MaterialApp(
              home: MockNavigatorProvider(
                navigator: navigator,
                child: const SearchScreen(),
              ),
            ),
          ),
        );
        await widgetTester.pump();

        await widgetTester.tap(find.text(data.albumEntity.title));
        mockito.verify(albumBloc.add(data.albumEntity.id));
        verify(
          () => navigator.pushNamed(
            '/album',
            arguments: data.albumEntity.title,
          ),
        );
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
            child: MaterialApp(
              home: MockNavigatorProvider(
                navigator: navigator,
                child: const SearchScreen(),
              ),
            ),
          ),
        );
        await widgetTester.pump();

        await widgetTester.dragUntilVisible(
          find.text(data.playlistEntity.title),
          find.byType(CustomScrollView),
          const Offset(0, -100),
        );
        await widgetTester.tap(find.text(data.playlistEntity.title));
        expect(
          (mockito.verify(playlistBloc.add(mockito.captureAny)).captured.single
                  as PlaylistEvent)
              .id,
          data.playlistEntity.id,
        );
        verify(
          () => navigator.pushNamed(
            '/playlist',
            arguments: data.playlistEntity.title,
          ),
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

class MockSearchResultsBloc extends MockBloc<String, SearchState>
    implements SearchResultsBloc {}

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}
