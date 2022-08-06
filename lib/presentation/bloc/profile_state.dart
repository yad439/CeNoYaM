import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.unknown() = _Unknown;
  const factory ProfileState.anonimous() = _Anonymous;
  const factory ProfileState.loggedIn(String username) = _LoggedIn;
}
