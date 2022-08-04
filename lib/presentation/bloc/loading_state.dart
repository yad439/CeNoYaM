import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/track.dart';

part 'loading_state.freezed.dart';

@immutable
@freezed
class LoadingState<T> with _$LoadingState<T> {
  const factory LoadingState.uninitialized() = _Uninitialized;
  const factory LoadingState.loaded(T object) = _Loaded;
}

typedef PlaylistState = LoadingState<List<TrackMin>>;
