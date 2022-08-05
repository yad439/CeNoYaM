import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@Freezed(copyWith: true, equal: true)
class LoginFormState with _$LoginFormState {
  const factory LoginFormState(
    LoginState state,
    String login,
    String password,
  ) = _LoginFormState;
}

enum LoginState {
  initial,
  success,
  failure,
}
