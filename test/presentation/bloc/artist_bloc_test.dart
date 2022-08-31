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

@GenerateMocks([MusicRepository, Artist])
import 'artist_bloc_test.mocks.dart';

void main() {
  final repository = MockMusicRepository();
  final verificationArtist = MockArtist();

  setUp(() {
    final mockArtist = MockArtist();
    when(repository.getArtist(any)).thenAnswer((_) async => mockArtist);
    when(mockArtist.id).thenReturn(1);
  });

  tearDown(() {
    reset(repository);
  });

  blocTest<ArtistBloc, ArtistState>(
    'Loads artist',
    build: () => ArtistBloc(repository),
    act: (bloc) => bloc.add(const ArtistEvent.load(1, null)),
    skip: 1,
    expect: () => [
      predicate(
        (ArtistState state) =>
            state.maybeMap(loaded: (_) => true, orElse: () => false),
      )
    ],
  );

  blocTest<ArtistBloc, ArtistState>(
    'Fetches additional info',
    build: () => ArtistBloc(repository),
    setUp: () =>
        when(repository.getArtist(1, subcategory: ArtistSubcategory.tracks))
            .thenAnswer((_) async => verificationArtist),
    act: (bloc) => bloc
      ..add(const ArtistEvent.load(1, null))
      ..add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.tracks)),
    verify: (bloc) => expect(
      bloc.state,
      (ArtistState state) => state.maybeWhen(
        loaded: (artist) => identical(artist, verificationArtist),
        orElse: () => false,
      ),
    ),
  );

  test('Fetches even in case of long response', () async {
    final bloc = ArtistBloc(repository);
    final mockArtist = MockArtist();
    final response = Completer<Artist>();
    when(repository.getArtist(any)).thenAnswer((_) => response.future);
    when(mockArtist.id).thenReturn(1);
    when(repository.getArtist(1, subcategory: ArtistSubcategory.tracks))
        .thenAnswer((_) async => verificationArtist);

    bloc
      ..add(const ArtistEvent.load(1, null))
      ..add(const ArtistEvent.fetchAdditinal(ArtistSubcategory.tracks));

    await Future<void>.delayed(const Duration(milliseconds: 100));
    response.complete(mockArtist);

    await Future<void>.delayed(const Duration(milliseconds: 100));
    await bloc.close();

    expect(
      bloc.state,
      (ArtistState state) => state.maybeWhen(
        loaded: (artist) => identical(artist, verificationArtist),
        orElse: () => false,
      ),
    );
  });
}
