import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/artist.dart';

part 'artist_state.freezed.dart';

@freezed
class ArtistState with _$ArtistState {
  const factory ArtistState.initial() = _Initial;
  const factory ArtistState.loading(int id) = _Loading;
  const factory ArtistState.loaded(Artist artist) = _Loaded;
}
