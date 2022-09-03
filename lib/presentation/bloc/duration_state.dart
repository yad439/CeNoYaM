import 'package:freezed_annotation/freezed_annotation.dart';

part 'duration_state.freezed.dart';

@freezed
class DurationState with _$DurationState {
  const factory DurationState(Duration position, Duration duration) =
      _DurationState;
}
