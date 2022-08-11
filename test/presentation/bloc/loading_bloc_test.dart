import 'package:cenoyam/domain/entity/album.dart';
import 'package:cenoyam/domain/entity/playlist.dart';
import 'package:cenoyam/domain/music_repository.dart';
import 'package:cenoyam/presentation/bloc/album_bloc.dart';
import 'package:cenoyam/presentation/bloc/loading_state.dart';
import 'package:cenoyam/presentation/bloc/playlist_bloc.dart';
import 'package:cenoyam/presentation/bloc/playlist_event.dart';
import 'package:cenoyam/presentation/bloc/search_results_bloc.dart';
import 'package:cenoyam/presentation/bloc/track_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks(
  [
    MockSpec<MusicRepository>(),
    MockSpec<Album>(),
    MockSpec<Playlist>(),
  ],
)
import 'loading_bloc_test.mocks.dart';

void main() {
  final repository = MockMusicRepository();
  test('Album bloc loads', () {
    final bloc = AlbumBloc(repository);
    when(repository.getAlbum(any)).thenAnswer((_) async => MockAlbum());

    expect(bloc.state, isUninitialized);

    bloc.add(1);

    expect(
      bloc.stream,
      emitsInOrder([isLoaded]),
    );
  });

  test('Track bloc loads', () {
    final bloc = TrackBloc(repository);

    expect(bloc.state, isUninitialized);

    bloc.add(1);

    expect(
      bloc.stream,
      emitsInOrder([isLoaded]),
    );
  });

  test('Playlist bloc loads', () {
    final bloc = PlaylistBloc(repository);
    when(repository.getPlaylist(any, any))
        .thenAnswer((_) async => MockPlaylist());

    expect(bloc.state, isUninitialized);

    bloc.add(const PlaylistEvent.load('abc', 1));

    expect(
      bloc.stream,
      emitsInOrder([isLoaded]),
    );
  });

  test('Search bloc loads', () {
    final bloc = SearchResultsBloc(repository);

    expect(bloc.state, isUninitialized);

    bloc.add('qwerty');

    expect(
      bloc.stream,
      emitsInOrder([isLoaded]),
    );
  });
}

bool isUninitialized(LoadingState<Object> state) =>
    state.maybeMap(uninitialized: (_) => true, orElse: () => false);
bool isLoaded(LoadingState<Object> state) =>
    state.maybeMap(loaded: (_) => true, orElse: () => false);
