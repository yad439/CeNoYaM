// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/domain/entity/artist.dart';
import 'package:cenoyam/domain/enum/artist_subcategory.dart';
import 'package:cenoyam/domain/music_repository.dart';
import 'package:cenoyam/presentation/bloc/artist_bloc.dart';
import 'package:cenoyam/presentation/bloc/artist_event.dart';
import 'package:cenoyam/presentation/bloc/artist_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_data.dart';
@GenerateMocks([MusicRepository, Artist])
import 'artist_bloc_test.mocks.dart';

void main() {
  final repository = MockMusicRepository();
  late final TestData data;

  setUpAll(() {
    data = TestData();
  });

  setUp(() {
    when(repository.getArtist(any)).thenAnswer((_) async => data.artistEntity);
    when(
      repository.getArtist(
        data.artistEntity.id,
        subcategory: ArtistSubcategory.tracks,
      ),
    ).thenAnswer((_) async => data.artistTracksEntity);
    when(
      repository.getArtist(
        data.artistEntity.id,
        subcategory: ArtistSubcategory.albums,
      ),
    ).thenAnswer((_) async => data.artistAlbumsEntity);
  });

  tearDown(() {
    reset(repository);
  });

  blocTest<ArtistBloc, ArtistState>(
    'Loads artist',
    build: () => ArtistBloc(repository),
    act: (bloc) => bloc.add(ArtistEvent.load(data.artistEntity.id, null)),
    skip: 1,
    expect: () => [
      predicate(
        (ArtistState state) =>
            state.maybeMap(loaded: (_) => true, orElse: () => false),
      )
    ],
  );

  blocTest<ArtistBloc, ArtistState>(
    'Fetches additional tracks',
    build: () => ArtistBloc(repository),
    act: (bloc) => bloc
      ..add(ArtistEvent.load(data.artistEntity.id, null))
      ..add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.tracks)),
    verify: (bloc) => expect(
      bloc.state,
      (ArtistState state) => state.maybeWhen(
        loaded: (artist) => artist.popularTracks.length == 3,
        orElse: () => false,
      ),
    ),
  );

  blocTest<ArtistBloc, ArtistState>(
    'Fetches additional tracks, then albums',
    build: () => ArtistBloc(repository),
    act: (bloc) => bloc
      ..add(ArtistEvent.load(data.artistEntity.id, null))
      ..add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.tracks))
      ..add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.albums)),
    verify: (bloc) => expect(
      bloc.state,
      (ArtistState state) => state.maybeWhen(
        loaded: (artist) => artist.albums.length == 2,
        orElse: () => false,
      ),
    ),
  );

  test('Fetches tracks even in case of long response', () async {
    final bloc = ArtistBloc(repository);
    final response = Completer<Artist>();
    when(repository.getArtist(any)).thenAnswer((_) => response.future);

    bloc
      ..add(ArtistEvent.load(data.artistEntity.id, null))
      ..add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.tracks));

    await Future<void>.delayed(const Duration(milliseconds: 100));
    response.complete(data.artistEntity);

    await Future<void>.delayed(const Duration(milliseconds: 100));
    await bloc.close();

    expect(
      bloc.state,
      (ArtistState state) => state.maybeWhen(
        loaded: (artist) => artist.popularTracks.length == 3,
        orElse: () => false,
      ),
    );
  });
  test('Fetches tracks and albums even in case of long response', () async {
    final bloc = ArtistBloc(repository);
    final firstResponse = Completer<Artist>();
    final secondResponse = Completer<Artist>();
    when(repository.getArtist(any)).thenAnswer((_) => firstResponse.future);
    when(repository.getArtist(any, subcategory: ArtistSubcategory.tracks))
        .thenAnswer((_) => secondResponse.future);

    bloc
      ..add(ArtistEvent.load(data.artistEntity.id, null))
      ..add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.tracks))
      ..add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.albums));

    await Future<void>.delayed(const Duration(milliseconds: 100));
    firstResponse.complete(data.artistEntity);
    secondResponse.complete(data.artistTracksEntity);

    await Future<void>.delayed(const Duration(milliseconds: 100));
    await bloc.close();

    expect(
      bloc.state,
      (ArtistState state) => state.maybeWhen(
        loaded: (artist) => artist.albums.length == 2,
        orElse: () => false,
      ),
    );
  });
}
