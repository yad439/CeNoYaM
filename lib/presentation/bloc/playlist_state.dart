import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/track.dart';

part 'playlist_state.freezed.dart';

@immutable
@freezed
class PlaylistState with _$PlaylistState {
  const factory PlaylistState.uninitialized() = _Uninitialized;
  const factory PlaylistState.loaded(List<TrackMin> tracks) = _Loaded;
}
